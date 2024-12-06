//
//  BasicHTMLTests.swift
//
//
//  Created by Taylor Lineman on 8/23/23.
//

import XCTest

@testable import SwiftHTMLtoMarkdown

final class BasicHTMLTests: XCTestCase {
    func testAll() throws {
        let raw = """
        <h1>Heading level 1</h1>
        <h2>Heading level 2</h2>
        <h3>Heading level 3</h3>
        <h4>Heading level 4</h4>
        <h5>Heading level 5</h5>
        <h6>Heading level 6</h6>
        <p>I just love <strong>bold text</strong>.</p>

        <p>Love<strong>is</strong>bold</p>

        <p>Italicized text is the <em>cat's meow</em>.</p>
        <p>A<em>cats</em>meow</p>

        <p>This text is <em><strong>really important</strong></em>.</p>

        <p>This is some code <code>Hello World!</code></p>

        <pre><code><span class="hljs-attribute">Hello World</span></code></pre>

        <pre><code class="lang-swift"><span class="hljs-attribute">Hello World</span></code></pre>
        """
        let correctOutput = """
        # Heading level 1

        ## Heading level 2

        ### Heading level 3

        #### Heading level 4

        ##### Heading level 5

        ###### Heading level 6

        I just love **bold text**.

        Love**is**bold

        Italicized text is the *cat's meow*.

        A*cats*meow

        This text is ***really important***.

        This is some code `Hello World!`

        ```
        Hello World
        ```

        ```swift
        Hello World
        ```
        """
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testHeaderLevelOne() throws {
        let raw = "<h1>Heading level 1</h1>"
        let correctOutput = """
        # Heading level 1


        """
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testHeaderLevelTwo() throws {
        let raw = "<h2>Heading level 2</h2>"
        let correctOutput = """
        ## Heading level 2


        """
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testHeaderLevelThree() throws {
        let raw = "<h3>Heading level 3</h3>"
        let correctOutput = """
        ### Heading level 3


        """
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testHeaderLevelFour() throws {
        let raw = "<h4>Heading level 4</h4>"
        let correctOutput = """
        #### Heading level 4


        """
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testHeaderLevelFive() throws {
        let raw = "<h5>Heading level 5</h5>"
        let correctOutput = """
        ##### Heading level 5


        """
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testHeaderLevelSix() throws {
        let raw = "<h6>Heading level 6</h6>"
        let correctOutput = """
        ###### Heading level 6


        """
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testParagraph() throws {
        let raw = "<p>Paragraphs are pretty fun</p>"
        let correctOutput = "Paragraphs are pretty fun"
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testBold() throws {
        let raw = "<p>I just love <strong>bold text</strong>.</p>"
        let correctOutput = "I just love **bold text**."
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testBoldWithNoLeadingOrTrailingSpaces() throws {
        let raw = "<p>Love<strong>is</strong>bold</p>"
        let correctOutput = "Love**is**bold"
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testItalicized() throws {
        let raw = "<p>Italicized text is the <em>cat's meow</em>.</p>"
        let correctOutput = "Italicized text is the *cat's meow*."
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testItalicizedWithNoLeadingOrTrailingSpaces() throws {
        let raw = "<p>A<em>cats</em>meow</p>"
        let correctOutput = "A*cats*meow"
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testItalicizedBoldText() throws {
        let raw = "<p>This text is <em><strong>really important</strong></em>.</p>"
        let correctOutput = "This text is ***really important***."
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testFencedCodeBlockWithLanguage() throws {
        let raw = """
        <pre><code class="lang-swift"><span class="hljs-attribute">Hello World</span></code></pre>
        """

        let correctOutput = """
        ```swift
        Hello World
        ```
        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testFencedCodeBlockWithoutLanguage() throws {
        let raw = """
        <pre><code><span class="hljs-attribute">Hello World</span></code></pre>
        """

        let correctOutput = """
        ```
        Hello World
        ```
        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testCode() throws {
        let raw = "<p>This is some code <code>Hello World!</code></p>"

        let correctOutput = "This is some code `Hello World!`"

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testImage() throws {
        let raw = "<img src=\"https://www.test.com/large.jpg\" alt=\"Alt text\">"

        let correctOutput = """

        ![Alt text](https://www.test.com/large.jpg)

        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testImageMultiple() throws {
        let raw =
            "<img src=\"https://www.test.com/one.jpg\" alt=\"Alt text\"><img src=\"https://www.test.com/two.jpg\" alt=\"Alt text\">"

        let correctOutput = """

        ![Alt text](https://www.test.com/one.jpg)

        ![Alt text](https://www.test.com/two.jpg)

        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    // func testImageSrcset() throws {
    //     let raw =
    //         "<img srcset=\"https://www.test.com/small.jpg 100w, https://www.test.com/medium.jpg 200w, https://www.test.com/large.jpg 300w\" alt=\"Alt text\">"

    //     let correctOutput = """

    //     ![Alt text](https://www.test.com/large.jpg)

    //     """

    //     var document = BasicHTML(rawHTML: raw)
    //     try document.parse()

    //     let markdown = try document.asMarkdown()
    //     print(markdown)
    //     XCTAssertTrue(markdown == correctOutput)
    // }

    func testImageNoAlt() throws {
        let raw = "<img src=\"https://www.test.com/large.jpg\">"

        let correctOutput = """

        ![](https://www.test.com/large.jpg)

        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testFigureImageWithCaption() throws {
        let raw = "<figure><img srcset=\"https://www.test.com/small.jpg%20100w,https://www.test.com/medium.jpg%20200w,https://www.test.com/large.jpg 300w\" alt=\"Alt text\"><figcaption>A caption</figcaption></figure>"

        let correctOutput = """

        ![A caption](https://www.test.com/large.jpg)

        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testFigureImageWithoutCaption() throws {
        let raw = "<figure><img srcset=\"https://www.test.com/small.jpg 100w, https://www.test.com/medium.jpg 200w, https://www.test.com/large.jpg 300w\" alt=\"Alt text\"></figure>"

        let correctOutput = """

        ![Alt text](https://www.test.com/large.jpg)

        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testUnorderedList() throws {
        let raw = "<ul><li>Item 1</li><li>Item 2</li><li>Item 3</li></ul>"

        let correctOutput = """
        - Item 1
        - Item 2
        - Item 3


        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testOrderedList() throws {
        let raw = "<ol><li>Item 1</li><li>Item 2</li><li>Item 3</li></ol>"

        let correctOutput = """
        0. Item 1
        1. Item 2
        2. Item 3


        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }

    func testHorizontalRule() throws {
        let raw = "<hr>"

        let correctOutput = """

        ---

        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown()
        print(markdown)
        XCTAssertTrue(markdown == correctOutput)
    }
}
