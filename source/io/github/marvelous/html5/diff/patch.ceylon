import io.github.marvelous.html5.syntax {
	Node,
	Text,
	Element,
	ProcessingInstruction,
	DocumentType,
	Comment,
	DocumentFragment,
	Document,
	ChildNode
}
import ceylon.collection {
	HashMap,
	ArrayList
}

shared Node patch(Node original, Patch patch) {
	switch (patch)
	case (is ReplaceNode) {
		return patch.node;
	}
	case (is TextContent) {
		switch (original)
		case (is Element) {
			return Element(original.tagName, original.attributes, [patch.text]);
		}
		case (is Text) {
			return patch.text;
		}
		case (is ProcessingInstruction) {
			return ProcessingInstruction(original.target, patch.text);
		}
		case (is Comment) {
			return Comment(patch.text);
		}
		case (is DocumentFragment) {
			return DocumentFragment([patch.text]);
		}
		case (is Document|DocumentType) {
			throw AssertionError("no text content: ``original``");
		}
	}
	case (is ChangeElement) {
		assert (is Element original);
		
		value attributes = HashMap { *original.attributes };
		for (name in patch.removeAttributes) {
			attributes.remove(name);
		}
		for (name->item in patch.setAttributes) {
			attributes.put(name, item);
		}
		
		value childNodes = ArrayList { *original.childNodes };
		for (index in patch.removeChildren) {
			childNodes.delete(index);
		}
		for (index->childPatch in patch.patchChildren) {
			value originalChild = childNodes.get(index);
			assert (exists originalChild);
			value newChild = package.patch(originalChild, childPatch);
			assert (is ChildNode newChild);
			childNodes.set(index, newChild);
		}
		for (node in patch.appendChildren) {
			childNodes.add(node);
		}
		
		return Element(original.tagName, attributes, childNodes);
	}
}
