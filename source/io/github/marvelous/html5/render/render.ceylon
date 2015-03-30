import io.github.marvelous.html5.diff {
	diff,
	Patch,
	ReplaceNode,
	ChangeElement,
	TextContent
}
import io.github.marvelous.html5.syntax {
	Node,
	Element,
	Text
}

shared dynamic DomDocument {
	shared formal DomNode createTextNode(String text);
	shared formal DomElement createElement(String name);
	shared formal DomElement? getElementById(String id);
}

shared dynamic DomNode {
	shared formal DomNode? parentNode;
	shared formal NodeList childNodes;
	shared formal DomDocument ownerDocument;
	shared formal variable String textContent;
	shared formal DomNode appendChild(DomNode aChild);
	shared formal DomNode replaceChild(DomNode newChild, DomNode oldChild);
	shared formal DomNode removeChild(DomNode child);
	
	shared formal variable Node? marvNode;
}

shared dynamic DomElement satisfies DomNode {
	shared formal variable String innerHTML;
	shared formal void removeAttribute(String attrName);
	shared formal void setAttribute(String name, String \ivalue);
}

shared dynamic NodeList {
	shared formal DomNode? item(Integer index);
}

DomNode create(Node node, DomDocument document) {
	switch (node)
	case (is Element) {
		DomElement element = document.createElement(node.tagName);
		for (name->val in node.attributes) {
			element.setAttribute(name, val);
		}
		for (child in node.childNodes) {
			element.appendChild(create(child, document));
		}
		return element;
	}
	case (is Text) {
		return document.createTextNode(node);
	}
	else {
		throw AssertionError("TODO");
	}
}

void patch(Patch patch, DomNode node, DomNode parent) {
	switch (patch)
	case (is ReplaceNode) {
		parent.replaceChild(create(patch.node, node.ownerDocument), node);
	}
	case (is TextContent) {
		node.textContent = patch.text;
	}
	case (is ChangeElement) {
		assert (is DomElement node);
		for (name in patch.removeAttributes) {
			node.removeAttribute(name);
		}
		for (name->val in patch.setAttributes) {
			node.setAttribute(name, val);
		}
		for (index in patch.removeChildren) {
			value child = node.childNodes.item(index);
			assert (exists child);
			node.removeChild(child);
		}
		for (index->childPatch in patch.patchChildren) {
			value child = node.childNodes.item(index);
			assert (exists child);
			package.patch(childPatch, child, node);
		}
		for (child in patch.appendChildren) {
			node.appendChild(create(child, node.ownerDocument));
		}
	}
}

shared void render(Node content, DomNode parent) {
	value previous = parent.marvNode;
	if (exists previous) {
		value patch = diff(previous, content);
		if (exists patch) {
			value child = parent.childNodes.item(0);
			assert (exists child);
			package.patch(patch, child, parent);
		}
	} else {
		while (exists child = parent.childNodes.item(0)) {
			parent.removeChild(child);
		}
		parent.appendChild(create(content, parent.ownerDocument));
	}
	parent.marvNode = content;
}
