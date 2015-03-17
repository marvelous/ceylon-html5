shared String polyglotString(Node node) {
	switch (node)
	case (is Element) {
		value tagName = node.tagName;
		value attributes = "".join(node.attributes.map((attribute) =>
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
			return "<``tagName````attributes``/>";
		}
		case ("script" | "style") {
			// 4.6.2 Raw text elements (script and style)
			value inner = textContent(node);
			assert (exists inner);
			return "<``tagName````attributes``>``inner``</``tagName``>";
		}
		else {
			value inner = "".join(node.childNodes.map(polyglotString));
			return "<``tagName````attributes``>``inner``</``tagName``>";
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
