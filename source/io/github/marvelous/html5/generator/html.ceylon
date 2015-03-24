import io.github.marvelous.html5.syntax.html {
	DataAttributes
}

interface AriaAttributes {}
interface EventAttributes {}

Attributes htmlElement = {
	// The following attributes are common to and may be specified on all HTML elements
	Attribute { "accesskey"; },
	// avoid conflict with JVM's Object.getClass
	Attribute { "class"; name = "className"; },
	Attribute { "contenteditable"; },
	Attribute { "contextmenu"; },
	Attribute { "dir"; },
	Attribute { "draggable"; },
	Attribute { "dropzone"; },
	Attribute { "hidden"; },
	Attribute { "id"; },
	Attribute { "itemid"; },
	Attribute { "itemprop"; },
	Attribute { "itemref"; },
	Attribute { "itemscope"; },
	Attribute { "itemtype"; },
	Attribute { "lang"; },
	Attribute { "xml:lang"; name = "xmlLang"; },
	Attribute { "spellcheck"; },
	Attribute { "style"; },
	Attribute { "tabindex"; },
	Attribute { "title"; },
	Attribute { "translate"; },
	// To enable assistive technology products to expose a more fine-grained interface than is otherwise possible with HTML elements and attributes, a set of annotations for assistive technology products can be specified
	Attribute { "role"; },
	Attribute { "ariaAttributes"; `AriaAttributes?`; },
	// The following event handler content attributes may be specified on any HTML element:
	Attribute { "eventAttributes"; `EventAttributes?`; },
	// Custom data attributes (e.g. data-foldername or data-msgid} can be specified on any HTML element, to store custom data specific to the page.
	Attribute { "dataAttributes"; `DataAttributes?`; },
	// In HTML documents, elements in the HTML namespace may have an xmlns attribute specified, if, and only if, it has the exact value "http://www.w3.org/1999/xhtml". This does not apply to XML documents.
	Attribute { "xmlns"; }
};

Declarations html = {
	AttributeGroup { `AriaAttributes`.declaration.name;
		Attribute { "aria-checked"; },
		Attribute { "aria-describedby"; },
		Attribute { "aria-disabled"; },
		Attribute { "aria-expanded"; },
		Attribute { "aria-hidden"; },
		Attribute { "aria-invalid"; },
		Attribute { "aria-label"; },
		Attribute { "aria-level"; },
		Attribute { "aria-multiline"; },
		Attribute { "aria-multiselectable"; },
		Attribute { "aria-owns"; },
		Attribute { "aria-readonly"; },
		Attribute { "aria-required"; },
		Attribute { "aria-selected"; },
		Attribute { "aria-sort"; },
		Attribute { "aria-valuemax"; },
		Attribute { "aria-valuemin"; },
		Attribute { "aria-valuenow"; }
	},
	AttributeGroup { `EventAttributes`.declaration.name;
		Attribute { "onabort"; },
		Attribute { "onautocomplete"; },
		Attribute { "onautocompleteerror"; },
		Attribute { "onblur"; },
		Attribute { "oncancel"; },
		Attribute { "oncanplay"; },
		Attribute { "oncanplaythrough"; },
		Attribute { "onchange"; },
		Attribute { "onclick"; },
		Attribute { "onclose"; },
		Attribute { "oncontextmenu"; },
		Attribute { "oncuechange"; },
		Attribute { "ondblclick"; },
		Attribute { "ondrag"; },
		Attribute { "ondragend"; },
		Attribute { "ondragenter"; },
		Attribute { "ondragexit"; },
		Attribute { "ondragleave"; },
		Attribute { "ondragover"; },
		Attribute { "ondragstart"; },
		Attribute { "ondrop"; },
		Attribute { "ondurationchange"; },
		Attribute { "onemptied"; },
		Attribute { "onended"; },
		Attribute { "onerror"; },
		Attribute { "onfocus"; },
		Attribute { "oninput"; },
		Attribute { "oninvalid"; },
		Attribute { "onkeydown"; },
		Attribute { "onkeypress"; },
		Attribute { "onkeyup"; },
		Attribute { "onload"; },
		Attribute { "onloadeddata"; },
		Attribute { "onloadedmetadata"; },
		Attribute { "onloadstart"; },
		Attribute { "onmousedown"; },
		Attribute { "onmouseenter"; },
		Attribute { "onmouseleave"; },
		Attribute { "onmousemove"; },
		Attribute { "onmouseout"; },
		Attribute { "onmouseover"; },
		Attribute { "onmouseup"; },
		Attribute { "onmousewheel"; },
		Attribute { "onpause"; },
		Attribute { "onplay"; },
		Attribute { "onplaying"; },
		Attribute { "onprogress"; },
		Attribute { "onratechange"; },
		Attribute { "onreset"; },
		Attribute { "onresize"; },
		Attribute { "onscroll"; },
		Attribute { "onseeked"; },
		Attribute { "onseeking"; },
		Attribute { "onselect"; },
		Attribute { "onshow"; },
		Attribute { "onsort"; },
		Attribute { "onstalled"; },
		Attribute { "onsubmit"; },
		Attribute { "onsuspend"; },
		Attribute { "ontimeupdate"; },
		Attribute { "ontoggle"; },
		Attribute { "onvolumechange"; },
		Attribute { "onwaiting"; }
	},
	// 4.1 The root element
	Element { "html";
		Attribute { "manifest"; },
		*htmlElement
	},
	// 4.2 Document metadata
	Element { "head";
		*htmlElement
	},
	Element { "title";
		*htmlElement
	},
	Element { "base";
		Attribute { "href"; },
		Attribute { "target"; },
		*htmlElement
	},
	Element { "link";
		Attribute { "href"; },
		Attribute { "crossorigin"; },
		Attribute { "rel"; },
		Attribute { "media"; },
		Attribute { "hreflang"; },
		Attribute { "type"; },
		Attribute { "sizes"; },
		*htmlElement
	},
	Element { "meta";
		Attribute { "name"; },
		Attribute { "http-equiv"; },
		Attribute { "content"; },
		Attribute { "charset"; },
		*htmlElement
	},
	Element { "style";
		Attribute { "media"; },
		Attribute { "type"; },
		Attribute { "scoped"; },
		*htmlElement
	},
	// 4.3 Sections
	Element { "body";
		Attribute { "onafterprint"; },
		Attribute { "onbeforeprint"; },
		Attribute { "onbeforeunload"; },
		Attribute { "onhashchange"; },
		Attribute { "onlanguagechange"; },
		Attribute { "onmessage"; },
		Attribute { "onoffline"; },
		Attribute { "ononline"; },
		Attribute { "onpagehide"; },
		Attribute { "onpageshow"; },
		Attribute { "onpopstate"; },
		Attribute { "onstorage"; },
		Attribute { "onunload"; },
		*htmlElement
	},
	Element { "article";
		*htmlElement
	},
	Element { "section";
		*htmlElement
	},
	Element { "nav";
		*htmlElement
	},
	Element { "aside";
		*htmlElement
	},
	Element { "h1";
		*htmlElement
	},
	Element { "h2";
		*htmlElement
	},
	Element { "h3";
		*htmlElement
	},
	Element { "h4";
		*htmlElement
	},
	Element { "h5";
		*htmlElement
	},
	Element { "h6";
		*htmlElement
	},
	Element { "header";
		*htmlElement
	},
	Element { "footer";
		*htmlElement
	},
	Element { "address";
		*htmlElement
	},
	// 4.4 Grouping content
	Element { "p";
		*htmlElement
	},
	Element { "hr";
		*htmlElement
	},
	Element { "pre";
		*htmlElement
	},
	Element { "blockquote";
		Attribute { "cite"; },
		*htmlElement
	},
	Element { "ol";
		Attribute { "reversed"; },
		Attribute { "start"; },
		Attribute { "type"; },
		*htmlElement
	},
	Element { "ul";
		*htmlElement
	},
	Element { "li";
		Attribute { "value"; },
		*htmlElement
	},
	Element { "dl";
		*htmlElement
	},
	Element { "dt";
		*htmlElement
	},
	Element { "dd";
		*htmlElement
	},
	Element { "figure";
		*htmlElement
	},
	Element { "figcaption";
		*htmlElement
	},
	Element { "main";
		*htmlElement
	},
	Element { "div";
		*htmlElement
	},
	// 4.5 Text-level semantics
	Element { "a";
		Attribute { "href"; },
		Attribute { "target"; },
		Attribute { "download"; },
		Attribute { "rel"; },
		Attribute { "hreflang"; },
		Attribute { "type"; },
		*htmlElement
	},
	Element { "em";
		*htmlElement
	},
	Element { "strong";
		*htmlElement
	},
	Element { "small";
		*htmlElement
	},
	Element { "s";
		*htmlElement
	},
	Element { "cite";
		*htmlElement
	},
	Element { "q";
		Attribute { "cite"; },
		*htmlElement
	},
	Element { "dfn";
		*htmlElement
	},
	Element { "abbr";
		*htmlElement
	},
	Element { "ruby";
		*htmlElement
	},
	Element { "rb";
		*htmlElement
	},
	Element { "rt";
		*htmlElement
	},
	Element { "rtc";
		*htmlElement
	},
	Element { "rp";
		*htmlElement
	},
	Element { "data";
		Attribute { "value"; },
		*htmlElement
	},
	Element { "time";
		Attribute { "datetime"; },
		*htmlElement
	},
	Element { "code";
		*htmlElement
	},
	Element { "var";
		*htmlElement
	},
	Element { "samp";
		*htmlElement
	},
	Element { "kbd";
		*htmlElement
	},
	Element { "sub";
		*htmlElement
	},
	Element { "sup";
		*htmlElement
	},
	Element { "i";
		*htmlElement
	},
	Element { "b";
		*htmlElement
	},
	Element { "u";
		*htmlElement
	},
	Element { "mark";
		*htmlElement
	},
	Element { "bdi";
		*htmlElement
	},
	Element { "bdo";
		*htmlElement
	},
	Element { "span";
		*htmlElement
	},
	Element { "br";
		*htmlElement
	},
	Element { "wbr";
		*htmlElement
	},
	// 4.6 Edits
	Element { "ins";
		Attribute { "cite"; },
		Attribute { "datetime"; },
		*htmlElement
	},
	Element { "del";
		Attribute { "cite"; },
		Attribute { "datetime"; },
		*htmlElement
	},
	// 4.7 Embedded content
	Element { "picture";
		*htmlElement
	},
	Element { "source";
		Attribute { "srcset"; },
		Attribute { "sizes"; },
		Attribute { "media"; },
		Attribute { "src"; },
		Attribute { "type"; },
		*htmlElement
	},
	Element { "img";
		Attribute { "alt"; },
		Attribute { "src"; },
		Attribute { "srcset"; },
		Attribute { "sizes"; },
		Attribute { "crossorigin"; },
		Attribute { "usemap"; },
		Attribute { "ismap"; },
		Attribute { "width"; },
		Attribute { "height"; },
		*htmlElement
	},
	Element { "iframe";
		Attribute { "src"; },
		Attribute { "srcdoc"; },
		Attribute { "name"; },
		Attribute { "sandbox"; },
		Attribute { "seamless"; },
		Attribute { "allowfullscreen"; },
		Attribute { "width"; },
		Attribute { "height"; },
		*htmlElement
	},
	Element { "embed";
		Attribute { "src"; },
		Attribute { "type"; },
		Attribute { "width"; },
		Attribute { "height"; },
		*htmlElement
	},
	Element { "object";
		Attribute { "data"; },
		Attribute { "type"; },
		Attribute { "typemustmatch"; },
		Attribute { "name"; },
		Attribute { "usemap"; },
		Attribute { "form"; },
		Attribute { "width"; },
		Attribute { "height"; },
		*htmlElement
	},
	Element { "param";
		Attribute { "name"; },
		Attribute { "value"; },
		*htmlElement
	},
	Element { "video";
		Attribute { "src"; },
		Attribute { "crossorigin"; },
		Attribute { "poster"; },
		Attribute { "preload"; },
		Attribute { "autoplay"; },
		Attribute { "mediagroup"; },
		Attribute { "loop"; },
		Attribute { "muted"; },
		Attribute { "controls"; },
		Attribute { "width"; },
		Attribute { "height"; },
		*htmlElement
	},
	Element { "audio";
		Attribute { "src"; },
		Attribute { "crossorigin"; },
		Attribute { "preload"; },
		Attribute { "autoplay"; },
		Attribute { "mediagroup"; },
		Attribute { "loop"; },
		Attribute { "muted"; },
		Attribute { "controls"; },
		*htmlElement
	},
	Element { "track";
		Attribute { "kind"; },
		Attribute { "src"; },
		Attribute { "srclang"; },
		Attribute { "label"; },
		Attribute { "default"; },
		*htmlElement
	},
	Element { "map";
		Attribute { "name"; },
		*htmlElement
	},
	Element { "area";
		Attribute { "alt"; },
		Attribute { "coords"; },
		Attribute { "download"; },
		Attribute { "href"; },
		Attribute { "hreflang"; },
		Attribute { "rel"; },
		Attribute { "shape"; },
		Attribute { "target"; },
		Attribute { "type"; },
		*htmlElement
	},
	// 4.8 Links
	
	// 4.9 Tabular data
	Element { "table";
		Attribute { "border"; },
		Attribute { "sorable"; },
		*htmlElement
	},
	Element { "caption";
		*htmlElement
	},
	Element { "colgroup";
		Attribute { "span"; },
		*htmlElement
	},
	Element { "col";
		Attribute { "span"; },
		*htmlElement
	},
	Element { "tbody";
		*htmlElement
	},
	Element { "thead";
		*htmlElement
	},
	Element { "tfoot";
		*htmlElement
	},
	Element { "tr";
		*htmlElement
	},
	Element { "td";
		Attribute { "colspan"; },
		Attribute { "rowspan"; },
		Attribute { "headers"; },
		*htmlElement
	},
	Element { "th";
		Attribute { "colspan"; },
		Attribute { "rowspan"; },
		Attribute { "headers"; },
		Attribute { "scope"; },
		Attribute { "abbr"; },
		Attribute { "sorted"; },
		*htmlElement
	},
	// 4.10 Forms
	Element { "form";
		Attribute { "accept-charset"; },
		Attribute { "action"; },
		Attribute { "autocomplete"; },
		Attribute { "enctype"; },
		Attribute { "method"; },
		Attribute { "name"; },
		Attribute { "novalidate"; `Boolean?`; },
		Attribute { "target"; },
		*htmlElement
	},
	Element { "label";
		Attribute { "form"; },
		Attribute { "for"; },
		*htmlElement
	},
	Element { "input";
		Attribute { "accept"; },
		Attribute { "alt"; },
		Attribute { "autocomplete"; },
		Attribute { "autofocus"; `Boolean?`; },
		Attribute { "checked"; `Boolean?`; },
		Attribute { "dirname"; },
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "form"; },
		Attribute { "formaction"; },
		Attribute { "formenctype"; },
		Attribute { "formmethod"; },
		Attribute { "formnovalidate"; `Boolean?`; },
		Attribute { "formtarget"; },
		Attribute { "height"; `Integer?`; },
		Attribute { "inputmode"; },
		Attribute { "list"; },
		Attribute { "max"; },
		Attribute { "maxlength"; `Integer?`; },
		Attribute { "min"; },
		Attribute { "minlength"; `Integer?`; },
		Attribute { "multiple"; `Boolean?`; },
		Attribute { "name"; },
		Attribute { "pattern"; },
		Attribute { "placeholder"; },
		Attribute { "readonly"; `Boolean?`; },
		Attribute { "required"; `Boolean?`; },
		Attribute { "size"; `Integer?`; },
		Attribute { "src"; },
		Attribute { "step"; },
		Attribute { "type"; },
		Attribute { "value"; },
		Attribute { "width"; `Integer?`; },
		*htmlElement
	},
	Element { "button";
		Attribute { "autofocus"; `Boolean?`; },
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "form"; },
		Attribute { "formaction"; },
		Attribute { "formenctype"; },
		Attribute { "formmethod"; },
		Attribute { "formnovalidate"; `Boolean?`; },
		Attribute { "formtarget"; },
		Attribute { "menu"; },
		Attribute { "name"; },
		Attribute { "type"; },
		Attribute { "value"; },
		*htmlElement
	},
	Element { "select";
		Attribute { "autofocus"; `Boolean?`; },
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "form"; },
		Attribute { "multiple"; `Boolean?`; },
		Attribute { "name"; },
		Attribute { "required"; `Boolean?`; },
		Attribute { "size"; `Integer?`; },
		*htmlElement
	},
	Element { "datalist";
		*htmlElement
	},
	Element { "optgroup";
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "label"; },
		*htmlElement
	},
	Element { "option";
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "label"; },
		Attribute { "selected"; `Boolean?`; },
		Attribute { "value"; },
		*htmlElement
	},
	Element { "textarea";
		Attribute { "autocomplete"; },
		Attribute { "autofocus"; `Boolean?`; },
		Attribute { "cols"; `Integer?`; },
		Attribute { "dirname"; },
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "form"; },
		Attribute { "inputmode"; },
		Attribute { "maxlength"; `Integer?`; },
		Attribute { "minlength"; `Integer?`; },
		Attribute { "name"; },
		Attribute { "placeholder"; },
		Attribute { "readonly"; `Boolean?`; },
		Attribute { "required"; `Boolean?`; },
		Attribute { "rows"; `Integer?`; },
		Attribute { "wrap"; },
		*htmlElement
	},
	Element { "keygen";
		Attribute { "autofocus"; `Boolean?`; },
		Attribute { "challenge"; },
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "form"; },
		Attribute { "keytype"; },
		Attribute { "name"; },
		*htmlElement
	},
	Element { "output";
		Attribute { "for"; },
		Attribute { "form"; },
		Attribute { "name"; },
		*htmlElement
	},
	Element { "progress";
		Attribute { "value"; `Float?`; },
		Attribute { "max"; `Float?`; },
		*htmlElement
	},
	Element { "meter";
		Attribute { "value"; `Float?`; },
		Attribute { "min"; `Float?`; },
		Attribute { "max"; `Float?`; },
		Attribute { "low"; `Float?`; },
		Attribute { "high"; `Float?`; },
		Attribute { "optimum"; `Float?`; },
		*htmlElement
	},
	Element { "fieldset";
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "form"; },
		Attribute { "name"; },
		*htmlElement
	},
	Element { "legend";
		*htmlElement
	},
	// 4.11 Interactive elements
	Element { "details";
		Attribute { "open"; `Boolean?`; },
		*htmlElement
	},
	Element { "summary";
		*htmlElement
	},
	Element { "menu";
		Attribute { "type"; },
		Attribute { "label"; },
		*htmlElement
	},
	Element { "menuitem";
		Attribute { "type"; },
		Attribute { "label"; },
		Attribute { "icon"; },
		Attribute { "disabled"; `Boolean?`; },
		Attribute { "checked"; `Boolean?`; },
		Attribute { "radiogroup"; },
		Attribute { "default"; `Boolean?`; },
		Attribute { "command"; },
		*htmlElement
	},
	Element { "dialog";
		Attribute { "open"; `Boolean?`; },
		*htmlElement
	},
	// 4.12 Scripting
	Element { "script";
		Attribute { "src"; },
		Attribute { "type"; },
		Attribute { "charset"; },
		Attribute { "async"; `Boolean?`; },
		Attribute { "defer"; `Boolean?`; },
		Attribute { "crossorigin"; },
		*htmlElement
	},
	Element { "noscript";
		*htmlElement
	},
	Element { "template";
		*htmlElement
	},
	Element { "canvas";
		Attribute { "width"; `Integer?`; },
		Attribute { "height"; `Integer?`; },
		*htmlElement
	}
	// 4.13 Common idioms without dedicated elements
	
	// 4.14 Disabled elements
};
