import ceylon.collection {
	HashMap
}
import ceylon.language.meta {
	type
}
import io.github.marvelous.html5.syntax {
	Node,
	Text,
	Element,
	ChildNode,
	xmlString
}

shared interface Patch of ReplaceNode | TextContent | ChangeElement {}

shared class ReplaceNode(shared Node node) satisfies Patch {}

shared class TextContent(shared String text) satisfies Patch {}

shared class ChangeElement(removeAttributes, setAttributes,
	removeChildren, patchChildren, appendChildren) satisfies Patch {
	
	shared {String*} removeAttributes;
	shared {<String->String>*} setAttributes;
	shared {Integer*} removeChildren;
	shared {<Integer->Patch>*} patchChildren;
	shared {ChildNode*} appendChildren;
	
	shared actual String string => className(this) + [
		"removeAttributes"->removeAttributes,
		"setAttributes"->setAttributes,
		"removeChildren"->removeChildren,
		"patchChildren"->patchChildren,
		"appendChildren"->appendChildren
	].string;
}

shared Patch? diff(Node from, Node to) {
	value fromType = type(from);
	value toType = type(to);
	if (fromType != toType) {
		return ReplaceNode(to);
	}
	
	switch (to)
	case (is Element) {
		assert (is Element from);
		return diffElement(from, to);
	}
	case (is Text) {
		assert (is Text from);
		return diffText(from, to);
	}
	else {
		throw AssertionError(xmlString(to));
	}
}

Patch? diffElement(Element from, Element to) {
	value fromName = from.tagName;
	value toName = to.tagName;
	
	if (fromName != toName) {
		return ReplaceNode(to);
	}
	
	value fromAttributes = HashMap { *from.attributes };
	
	value setAttributes = to.attributes
		.map((attribute) {
			value name = attribute.key;
			value toValue = attribute.item;
			if (exists fromValue = fromAttributes.remove(name), fromValue == toValue) {
				return null;
			}
			return name->toValue;
		})
		.coalesced
		.sequence();
	
	value removeAttributes = fromAttributes.keys.sequence();
	
	value fromChildSize = from.childNodes.size;
	value toChildSize = to.childNodes.size;
	value diffSize = toChildSize <=> fromChildSize;
	
	value removeChildren = diffSize == smaller then fromChildSize - 1 .. toChildSize else [];
	value appendChildren = diffSize == larger then to.childNodes.skip(fromChildSize) else [];
	
	value patchChildren = zipPairs(from.childNodes, to.childNodes)
		.indexed
		.map((entry) {
			value index = entry.key;
			value pair = entry.item;
			value from = pair[0];
			value to = pair[1];
			value patch = diff(from, to);
			if (exists patch) {
				return index->patch;
			}
			return null;
		})
		.coalesced;
	
	if (setAttributes.empty && removeAttributes.empty
				&& removeChildren.empty && patchChildren.empty && appendChildren.empty) {
		return null;
	}
	
	return ChangeElement(removeAttributes, setAttributes,
		removeChildren, patchChildren, appendChildren);
}

Patch? diffText(Text from, Text to) => from != to then TextContent(to);
