"""
   Serialize a DOM node using <a href="http://www.w3.org/TR/html-polyglot/">polyglot markup</a>.
   This function takes care of the following points of the specification:
   <ul>
   	<li>minimized tag syntax for void elements
   	<li>write the xml:lang attribute on the html element if the lang attribute is present
   	<li>surround all attributes in double quotation marks
   	<li>escape attribute values and text, except in raw text elements
   </ul>
   All the other points of the specification must be take care of when building the node, especially:
   <ul>
   	<li>use the &lt;!DOCTYPE html> doctype
   	<li>put an xmlns="http://www.w3.org/1999/xhtml" attribute on the html element
   </ul>
   Example use:
   
       value document = Document {
           DocumentType("html"),
           html {
               xmlns = "http://www.w3.org/1999/xhtml";
               lang = "en";
               head {
                   title { "Ceylon Community" }
               },
               body {
                   h2 { "Welcome ``you``, to Ceylon ``language.version``!" },
                   p { "Now get your code on :)" }
               }
           }
       };
       polyglotString(document);
   
"""
shared String polyglotString(Node node) {
	switch (node)
	case (is Element) {
		value tagName = node.tagName;
		
		{Attribute*} attributes;
		if (tagName == "html", exists lang = node.attributes.find((attribute) => attribute.key == "lang")) {
			attributes = node.attributes.follow("xml:lang"->lang.item);
		} else {
			attributes = node.attributes;
		}
		
		value attributesString = "".join(attributes.map((attribute) =>
					" ``attribute.key``=\"``attribute.item
						.replace("&", "&amp;")
						.replace("\t", "&#x9;")
						.replace("\r", "&#xa;")
						.replace("\n", "&#xd;")
						.replace("\"", "&quot;")
					``\""
			));
		
		switch (tagName)
		case ("area" | "base" | "br" | "col" | "embed" | "hr" | "img" | "input" | "keygen" | "link" | "meta" | "param" | "source" | "track" | "wbr") {
			// 4.6.1 Void elements
			return "<``tagName````attributesString``/>";
		}
		case ("script" | "style") {
			// 4.6.2 Raw text elements (script and style)
			value inner = textContent(node);
			assert (exists inner);
			return "<``tagName````attributesString``>``inner``</``tagName``>";
		}
		else {
			value inner = "".join(node.childNodes.map(polyglotString));
			return "<``tagName````attributesString``>``inner``</``tagName``>";
		}
	}
	case (is Text) {
		return node
			.replace("&", "&amp;")
			.replace("<", "&lt;");
	}
	case (is ProcessingInstruction) {
		if (node.data.empty) {
			return "<?``node.target``?>";
		} else {
			return "<?``node.target`` ``node.data``?>";
		}
	}
	case (is Comment) {
		return "<!--``node.data``-->";
	}
	case (is Document) {
		return "".join(node.childNodes.map(polyglotString));
	}
	case (is DocumentType) {
		if (node.publicId.empty && node.systemId.empty) {
			return "<!DOCTYPE ``node.name``>";
		} else if (node.publicId.empty) {
			return "<!DOCTYPE ``node.name`` SYSTEM \"``node.systemId``\">";
		} else {
			return "<!DOCTYPE ``node.name`` PUBLIC \"``node.publicId``\" \"``node.systemId``\">";
		}
	}
	case (is DocumentFragment) {
		return "".join(node.childNodes.map(polyglotString));
	}
}
