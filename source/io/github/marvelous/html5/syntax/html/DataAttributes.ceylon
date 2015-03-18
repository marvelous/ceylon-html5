import io.github.marvelous.html5.syntax {
	Attribute,
	AttributeGroup
}

shared final class DataAttributes(shared Attribute* unprefixed)
		extends AttributeGroup(unprefixed.map((attribute) =>
			("data-" + attribute.key)->attribute.item)) {
}
