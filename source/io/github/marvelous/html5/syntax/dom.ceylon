shared alias Text => String;
shared alias Node => Document|DocumentFragment|DocumentType|Element|Text|ProcessingInstruction|Comment;
shared alias CharacterData => Text|Comment|ProcessingInstruction;
shared alias Attribute => String->String;
shared alias NodeList => {Node*};
shared alias ChildNode => DocumentType|Element|CharacterData;

shared interface ParentNode of Document | DocumentFragment | Element {
	shared formal {ChildNode*} childNodes;
	shared {Element*} children => childNodes
		.map((child) { if (is Element child) { return child; } else { return null; } })
		.coalesced;
}

shared final class Document(shared actual {ChildNode*} childNodes) satisfies ParentNode {}
shared final class DocumentFragment(shared actual {ChildNode*} childNodes) satisfies ParentNode {}
shared final class DocumentType(shared String name, shared String publicId = "", shared String systemId = "") {}
shared final class ProcessingInstruction(shared String target, shared String data) {}
shared final class Comment(shared String data) {}

shared class AttributeGroup(shared {Attribute*} attributes) {
}

shared class Element(tagName, attributes, childNodes) extends AttributeGroup(attributes) satisfies ParentNode {
	shared String tagName;
	{Attribute*} attributes;
	shared actual {ChildNode*} childNodes;
}

shared {Attribute*} createAttributes(<String->Anything>* attributes) => attributes.flatMap((attribute) {
		if (exists item = attribute.item) {
			if (is AttributeGroup item) { return item.attributes; } else { return [attribute.key->item.string]; }
		} else { return []; }
	});

shared Element element(String tagName, Attribute|ChildNode* content) {
	value tagNameArg = tagName;
	return Element {
		tagName = tagNameArg;
		attributes = content
			.map((element) { if (is Attribute element) { return element; } else { return null; } })
			.coalesced;
		childNodes = content
			.map((element) { if (is ChildNode element) { return element; } else { return null; } })
			.coalesced;
	};
}

shared String nodeName(Node node) {
	switch (node)
	case (is Element) {
		return node.tagName;
	}
	case (is Text) {
		return "#text";
	}
	case (is ProcessingInstruction) {
		return node.target;
	}
	case (is Comment) {
		return "#comment";
	}
	case (is Document) {
		return "#document";
	}
	case (is DocumentType) {
		return node.name;
	}
	case (is DocumentFragment) {
		return "#document-fragment";
	}
}

shared {ChildNode*} childNodes(Node node) {
	switch (node)
	case (is ParentNode) {
		return node.childNodes;
	}
	else {
		return [];
	}
}

shared String? nodeValue(Node node) {
	switch (node)
	case (is CharacterData) {
		return data(node);
	}
	else {
		return null;
	}
}

shared String? textContent(Node node) {
	switch (node)
	case (is DocumentFragment|Element) {
		return "".join(
			childNodes(node)
				.map(textContent)
				.map((text) { if (exists text) { return text; } else { return null; } })
				.coalesced);
	}
	case (is CharacterData) {
		return data(node);
	}
	else {
		return null;
	}
}

shared String data(CharacterData node) {
	switch (node)
	case (is Text) {
		return node;
	}
	case (is Comment) {
		return node.data;
	}
	case (is ProcessingInstruction) {
		return node.data;
	}
}
