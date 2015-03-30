import ceylon.test {
	test,
	assertEquals
}
import io.github.marvelous.html5.syntax.html {
	html,
	div
}
import io.github.marvelous.html5.syntax {
	Node,
	Element
}

void assertIterableEquals<Element>({Element*} a, {Element*} b, void assertElementEquals(Element a, Element b) => assertEquals(a, b)) {
	assertEquals(a.size, b.size);
	for (pair in zipPairs(a, b)) {
		assertElementEquals(pair[0], pair[1]);
	}
}

void assertNodeEquals(Node a, Node b) {
	if (is Element a, is Element b) {
		assertEquals(a.tagName, b.tagName);
		assertIterableEquals(a.attributes, b.attributes);
		assertIterableEquals(a.childNodes, b.childNodes, assertNodeEquals);
	} else {
		assertEquals(a, b);
	}
}

void assertPatchEquals(Patch? a, Patch? b) {
	if (is ReplaceNode a, is ReplaceNode b) {
		assertNodeEquals(a.node, b.node);
	} else if (is ChangeElement a, is ChangeElement b) {
		assertIterableEquals(a.removeAttributes, b.removeAttributes);
		assertIterableEquals(a.setAttributes, b.setAttributes);
		assertIterableEquals(a.removeChildren, b.removeChildren);
		assertIterableEquals(a.patchChildren, b.patchChildren,
			void(Integer->Patch a, Integer->Patch b) {
				assertEquals(a.key, b.key);
				assertPatchEquals(a.item, b.item);
			});
		assertIterableEquals(a.appendChildren, b.appendChildren, assertNodeEquals);
	} else if (is TextContent a, is TextContent b) {
		assertEquals(a.text, b.text);
	} else {
		assertEquals(a, b);
	}
}

test
shared void testDiff() {
	assertPatchEquals(diff(html { }, html { }), null);
	assertPatchEquals(diff(html { "x" }, div { "x" }), ReplaceNode(div { "x" }));
	assertPatchEquals(diff("", "x"), TextContent("x"));
	assertPatchEquals(diff(html { title = "x"; }, html { }), ChangeElement(["title"], [], [], [], []));
	assertPatchEquals(diff(html { }, html { title = "x"; }), ChangeElement([], ["title"->"x"], [], [], []));
	assertPatchEquals(diff(html { }, html { "x" }), ChangeElement([], [], [], [], ["x"]));
	assertPatchEquals(diff(html { "x" }, html { }), ChangeElement([], [], [0], [], []));
	assertPatchEquals(diff(html { "x" }, html { div { } }), ChangeElement([], [], [], [0->ReplaceNode(div { })], []));
	assertPatchEquals(diff(html { "" }, html { "x" }), ChangeElement([], [], [], [0->TextContent("x")], []));
}

test
shared void testPatch() {
	void testPatch(Node from, Node to) {
		value patch = diff(from, to);
		assert (exists patch);
		assertNodeEquals(package.patch(from, patch), to);
	}
	testPatch(html { "x" }, div { "x" });
	testPatch("", "x");
	testPatch(html { title = "x"; }, html { });
	testPatch(html { }, html { title = "x"; });
	testPatch(html { }, html { "x" });
	testPatch(html { "x" }, html { });
	testPatch(html { "x" }, html { div { } });
	testPatch(html { "" }, html { "x" });
}
