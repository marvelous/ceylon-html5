"""
   Serialize a DOM node like using the XML syntax.
   Example use:
   
       value document = Document {
           ProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\""),
           DocumentType("html", "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"),
           html {
               xmlns = "http://www.w3.org/1999/xhtml";
               xmlLang = "en";
               head {
                   title { "Ceylon Community" }
               },
               body {
                   h2 { "Welcome ``you``, to Ceylon ``language.version``!" },
                   p { "Now get your code on :)" }
               }
           }
       };
       xmlString(document);
   
   """
shared String xmlString(Node node) {
	switch (node)
	case (is Element) {
		value tagName = node.tagName;
		
		{Attribute*} attributes = node.attributes;
		
		value attributesString = "".join(attributes.map((attribute) =>
					" ``attribute.key``=\"``attribute.item
						.replace("&", "&amp;")
						.replace("\t", "&#x9;")
						.replace("\r", "&#xa;")
						.replace("\n", "&#xd;")
						.replace("\"", "&quot;")
					``\""
			));
		
		value inner = "".join(node.childNodes.map(xmlString));
		return "<``tagName````attributesString``>``inner``</``tagName``>";
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
		return "".join(node.childNodes.map(xmlString));
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
		return "".join(node.childNodes.map(xmlString));
	}
}
