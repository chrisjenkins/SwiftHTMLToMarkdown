import SwiftSoup

public class BasicHTML: HTML {
    public var rawHTML: String
    public var document: Document?
    public var rawText: String = ""
    public var markdown: String = ""
    var hasSpacedParagraph: Bool = false

    public required init() {
        rawHTML = "Document not initialized correctly"
    }

    /// Converts the given node into valid Markdown by appending it onto the ``MastodonHTML/markdown`` property.
    /// - Parameter node: The node to convert
    public func convertNode(_ node: Node, parentNode: Node? = nil, index: Int = 0) throws {
        switch node.nodeName() {
            case "h1", "h2", "h3", "h4", "h5", "h6":
                guard let last = node.nodeName().last else {
                    return
                }
                guard let level = Int(String(last)) else {
                    return
                }

                for _ in 0 ..< level {
                    markdown += "#"
                }

                markdown += " "

                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: node, index: idx)
                }

                markdown += "\n\n"
                return

            case "p":
                if hasSpacedParagraph {
                    markdown += "\n\n"
                } else {
                    hasSpacedParagraph = true
                }

            case "br":
                if hasSpacedParagraph {
                    markdown += "\n"
                } else {
                    hasSpacedParagraph = true
                }

            case "a":
                markdown += "["
                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: node, index: idx)
                }
                markdown += "]"

                let href = try node.attr("href")
                markdown += "(\(href))"
                return

            case "strong":
                markdown += "**"
                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: node, index: idx)
                }
                markdown += "**"
                return

            case "em":
                markdown += "*"
                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: node, index: idx)
                }
                markdown += "*"
                return

            case "code" where parentNode?.nodeName() != "pre":
                markdown += "`"
                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: node, index: idx)
                }
                markdown += "`"
                return

            case "pre" where node.childNodeSize() >= 1:
                if hasSpacedParagraph {
                    markdown += "\n\n"
                } else {
                    hasSpacedParagraph = true
                }

                let codeNode = node.childNode(0)

                if codeNode.nodeName() == "code" {
                    markdown += "```"

                    // Try and get the language from the code block
                    if let codeClass = try? codeNode.attr("class"),
                       let match = try? #/lang.*-(\w+)/#.firstMatch(in: codeClass)
                    {
                        // match.output.1 is equal to the second capture group.
                        let language = match.output.1
                        markdown += language + "\n"
                    } else {
                        // Add the ending newline that we need to format this correctly.
                        markdown += "\n"
                    }

                    for (idx, child) in node.getChildNodes().enumerated() {
                        try convertNode(child, parentNode: node, index: idx)
                    }
                    markdown += "\n```"
                    return
                }
                
            case "div" where parentNode?.nodeName() == "figure":
                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: parentNode, index: idx)
                }
                return

            case "figcaption": // ignore these outside of a figure
                return

            case "span" where parentNode?.nodeName() == "figure":
                return

            case "img" where parentNode?.nodeName() == "figure":
                guard
                    let srcSet = try? node.attr("srcset"), !srcSet.isEmpty
                else {
                    return
                }

                let srcSetComponents = srcSet
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                guard
                    let srcSize = srcSetComponents.last
                else {
                    return
                }

                let srcSizeComponents = srcSize
                    .replacingOccurrences(of: "%20", with: " ")
                    .components(separatedBy: " ")

                guard
                    let url = srcSizeComponents.first
                else {
                    return
                }

                markdown += "\n"
                markdown += "!["

                var didFindCaption = false
                if let parentNode {
                    for child in parentNode.getChildNodes() where child.nodeName() == "figcaption" {
                        for grandChild in child.getChildNodes() where grandChild.nodeName() == "#text" && grandChild.description != " " {
                            markdown += grandChild.description.trimmingCharacters(in: .newlines)
                        }
                        didFindCaption = true
                        break
                    }
                }

                if !didFindCaption, let alt = try? node.attr("alt").trimmingCharacters(in: .whitespacesAndNewlines), !alt.isEmpty {
                    markdown += alt
                }

                markdown += "]("
                markdown += url
                markdown += ")"
                markdown += "\n"
                return

            case "img":
                if let src = try? node.attr("src"), !src.isEmpty {
                    markdown += "\n"
                    markdown += "!["
                    if let alt = try? node.attr("alt").trimmingCharacters(in: .whitespacesAndNewlines), !alt.isEmpty {
                        markdown += alt
                    }
                    markdown += "]("

                    let srcSetComponents = src
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                    guard
                        let srcSize = srcSetComponents.last
                    else {
                        return
                    }

                    let srcSizeComponents = srcSize
                        .replacingOccurrences(of: "%20", with: " ")
                        .components(separatedBy: " ")

                    guard
                        let url = srcSizeComponents.first
                    else {
                        return
                    }

                    markdown += url
                    markdown += ")"
                }
                markdown += "\n"

            case "blockquote":
                // Blockquote conversion
                markdown += "> "
                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: node, index: idx)
                }
                markdown += "\n\n"

            case "ul", "ol":
                // List conversion
                for (idx, child) in node.getChildNodes().enumerated() {
                    try convertNode(child, parentNode: node, index: idx)
                }
                markdown += "\n"
                return

            case "li":
                // List item conversion
                switch parentNode?.nodeName() {
                    case "ul":
                        markdown += "- "
                        for (idx, child) in node.getChildNodes().enumerated() {
                            try convertNode(child, parentNode: node, index: idx)
                        }
                        markdown += "\n"

                    case "ol":
                        markdown += "\(index). "
                        for (idx, child) in node.getChildNodes().enumerated() {
                            try convertNode(child, parentNode: node, index: idx)
                        }
                        markdown += "\n"

                    default: break
                }
                return // do not parse any further

            case "hr":
                // Horizontal rule conversion
                markdown += "\n---\n"

            default:
                break
        }

        if node.nodeName() == "#text" && node.description != " " {
            markdown += node.description.trimmingCharacters(in: .newlines)
        }

        for (idx, child) in node.getChildNodes().enumerated() {
            try convertNode(child, parentNode: node, index: idx)
        }
    }
}
