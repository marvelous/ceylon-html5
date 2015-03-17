import io.github.marvelous.html5.syntax {
	Attribute,
	AttributeGroup
}

shared class DataAttributes(shared Attribute* unprefixed) satisfies AttributeGroup {
	shared actual {Attribute*} attributes
			=> unprefixed.map((attribute) => ("data-" + attribute.key)->attribute.item);
}
