import ceylon.ast.core {
	CompilationUnit,
	DefaultedValueParameter,
	ValueParameter,
	Specifier,
	AstType=Type,
	AstUnionType=UnionType,
	PrimaryType,
	IntersectionType,
	FullPackageName,
	LIdentifier,
	StringLiteral,
	Return,
	EntryOperation,
	Import,
	ImportElements,
	ImportTypeElement,
	ImportFunctionValueElement,
	ValueDefinition
}
import ceylon.ast.create {
	baseExpression,
	lidentifier,
	annotations,
	baseType,
	invocation,
	functionDefinition,
	uidentifier,
	classDefinition
}
import ceylon.ast.redhat {
	SimpleTokenFactory,
	RedHatTransformer
}
import ceylon.formatter {
	format
}
import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
	Package
}
import ceylon.language.meta.model {
	MetaType=Type,
	MetaUnionType=UnionType,
	MetaClassOrInterface=ClassOrInterface
}
import io.github.marvelous.html5.syntax {
	SyntaxAttributeGroup=AttributeGroup,
	SyntaxElement=Element,
	DocumentType,
	Comment,
	ProcessingInstruction,
	createElement,
	createAttributes
}

alias Attributes => {Attribute*};
alias Declarations => {Declaration*};
class Attribute(shared String xmlName, shared MetaType metaType = `String?`,
	shared String name = ceylonName(xmlName),
	shared AstType astType = typeAst(metaType)) {}
abstract class Declaration(shared String name, shared Attributes attributes) of AttributeGroup | Element {}
class AttributeGroup(String name, Attributes attributes) extends Declaration(name, attributes) {}
class Element(String name, Attributes attributes) extends Declaration(name, attributes) {}

String ceylonName(String xmlName) => xmlName.fold(["", false])(
	(state, character) => character == '-'
				then [state[0], true]
				else [state[0] + (state[1]
						then character.uppercased
						else character
			).string, false]
)[0];

IntersectionType|PrimaryType unionableAst(MetaType meta) {
	if (is MetaClassOrInterface meta) {
		return baseType(meta.declaration.name, *meta.typeArguments.map((meta) => typeAst(meta.item)));
	} else {
		print(type(meta).satisfiedTypes);
		assert (false);
	}
}
AstType typeAst(MetaType meta) {
	if (is MetaUnionType meta) {
		value caseTypes = meta.caseTypes.map((meta) => unionableAst(meta)).sequence();
		assert (nonempty caseTypes);
		return AstUnionType(caseTypes);
	} else {
		return unionableAst(meta);
	}
}

FullPackageName fullPackageName(Package pkg) {
	value components = pkg.name.split('.'.equals).map(lidentifier).sequence();
	assert (is [LIdentifier+] components);
	return FullPackageName(components);
}

shared void run() {
	value types = html;
	value unit = CompilationUnit {
		imports = [
			Import(
				fullPackageName(`package io.github.marvelous.html5.syntax`),
				ImportElements(
					[
						ImportTypeElement(uidentifier(`interface SyntaxAttributeGroup`.name)),
						ImportTypeElement(uidentifier(`class SyntaxElement`.name)),
						ImportTypeElement(uidentifier(`class DocumentType`.name)),
						ImportTypeElement(uidentifier(`class Comment`.name)),
						ImportTypeElement(uidentifier(`class ProcessingInstruction`.name)),
						ImportFunctionValueElement(lidentifier(`function createAttributes`.name)),
						ImportFunctionValueElement(lidentifier(`function createElement`.name))
					]
				)
			)
		];
		declarations = types
			.map((type) {
				value element = type is Element;
				
				value parameters = type.attributes
					.map((attribute) {
						value parameter = ValueParameter {
							attribute.astType;
							lidentifier(attribute.name);
						};
						if (attribute.metaType.typeOf(null)) {
							return DefaultedValueParameter(parameter, Specifier(baseExpression(`value null`.name)));
						} else if (attribute.metaType.typeOf(empty)) {
							return DefaultedValueParameter(parameter, Specifier(baseExpression(`value empty`.name)));
						}
						return parameter;
					})
					.sort((x, y) => x is ValueParameter
								then (y is ValueParameter then equal else smaller)
								else (y is ValueParameter then larger else equal));
				
				value attributes = invocation {
					baseExpression(`function createAttributes`.name);
					*type.attributes.map((attribute) =>
							EntryOperation(
								StringLiteral(attribute.xmlName),
								baseExpression(lidentifier(attribute.name))
							)
					)
				};
				
				if (element) {
					return functionDefinition {
						annotations = annotations {
							`function shared`.name
						};
						type = typeAst(`SyntaxElement`);
						name = ceylonName(type.name);
						parameters = parameters.follow(
							ValueParameter {
								typeAst(`SyntaxElement.childNodes`.type);
								lidentifier(`SyntaxElement.childNodes`.declaration.name);
							}
						);
						Return(
							invocation {
								baseExpression(`function createElement`.name);
								StringLiteral(type.name),
								baseExpression(lidentifier(`SyntaxElement.childNodes`.declaration.name)),
								attributes
							}
						)
					};
				} else {
					return classDefinition {
						annotations = annotations {
							`function shared`.name
						};
						name = type.name;
						satisfiedTypes = [`SyntaxAttributeGroup`.declaration.name];
						parameters = parameters;
						ValueDefinition {
							annotations = annotations {
								`function shared`.name,
								`function actual`.name
							};
							type = typeAst(`SyntaxAttributeGroup.attributes`.type);
							name = lidentifier(`SyntaxAttributeGroup.attributes`.declaration.name);
							definition = Specifier(attributes);
						}
					};
				}
			}
		).sequence();
	};
	format(unit.transform(RedHatTransformer(SimpleTokenFactory())));
}
