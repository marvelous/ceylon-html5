import ceylon.collection {
	HashMap,
	HashSet,
	ArrayList
}
import ceylon.file {
	lines,
	File,
	parsePath
}
import ceylon.interop.java {
	CeylonIterable,
	JavaList,
	javaString,
	javaClass
}
import com.redhat.ceylon.cmr.api {
	ModuleQuery,
	ArtifactContext,
	ModuleDependencyInfo,
	ArtifactResult,
	RepositoryManager
}
import com.redhat.ceylon.cmr.ceylon {
	RepoUsingTool
}
import com.redhat.ceylon.cmr.impl {
	JSUtils
}
import com.redhat.ceylon.common {
	ModuleUtil,
	Versions
}
import com.redhat.ceylon.common.tool {
	summary,
	description,
	description__SETTER,
	optionArgument__SETTER,
	argument__SETTER,
	ToolFactory
}
import com.redhat.ceylon.common.tools {
	CeylonToolLoader,
	CeylonTool
}
import java.io {
	StringReader
}
import java.lang {
	JInteger=Integer
}
import java.net {
	URI
}
import java.util {
	PropertyResourceBundle
}

// TODO: load some messages
String messages = "";

summary ("Packs JavaScript modules in a single file")
description ("""Packs the ceylon program specified as the `<module>` argument, with 
                all its dependencies. The `<module>` may optionally include a version.""")
shared class CeylonPackJsTool() extends RepoUsingTool(PropertyResourceBundle(StringReader(""))) {
	
	optionArgument__SETTER { argumentName = "func"; }
	description__SETTER ("The function to run, which must be exported from the given `<module>`. (default: `run`).")
	shared variable String func = "run";

	argument__SETTER { argumentName = "module"; multiplicity = "1"; order = 1; }
	shared variable String moduleSpec = RepositoryManager.\iDEFAULT_MODULE;
	
	shared actual void initialize(CeylonTool tool) {}
	
	shared actual void run() {
		String packed = pack(moduleSpec);
		print(packed);
	}
	
	shared String pack(String moduleSpec) {
		value moduleSpecName = ModuleUtil.moduleName(moduleSpec);
		value moduleSpecVersion = ModuleUtil.moduleVersion(moduleSpec) of String?;
		
		value moduleName = moduleSpecName;
		value moduleVersion = checkModuleVersionsOrShowSuggestions(
			repositoryManager,
			moduleSpecName, moduleSpecVersion,
			ModuleQuery.Type.\iJS,
			JInteger(Versions.\iJS_BINARY_MAJOR_VERSION),
			JInteger(Versions.\iJS_BINARY_MINOR_VERSION)
		) of String?;
		assert (exists moduleVersion);
		
		class ModuleInfo(shared String key, shared String name, shared String version,
			shared ArtifactResult js, shared ArtifactResult jsModel,
			shared {ModuleDependencyInfo*} dependencies, shared variable Integer uses = 0) {
			shared String jsName =
					name.replace(".", "/") + "/" + version + "/" + name + "-" + version;
			shared actual String string => key;
		}
		value modules = HashMap<String,ModuleInfo>();
		
		ModuleInfo getModule(String moduleName, String moduleVersion) {
			String key = "``moduleName``/``moduleVersion``";
			
			value info = modules[key];
			if (exists info) {
				return info;
			}
			
			value js = getArtifact(moduleName, moduleVersion, ArtifactContext.\iJS);
			value jsModel = getArtifact(moduleName, moduleVersion, ArtifactContext.\iJS_MODEL);
			value dependencies = CeylonIterable(JSUtils.\iINSTANCE.resolve(jsModel, null).dependencies);
			
			value info2 = ModuleInfo(key, moduleName, moduleVersion, js, jsModel, dependencies);
			modules.put(key, info2);
			
			for (dep in dependencies) {
				getModule(dep.name, dep.version).uses += 1;
			}
			
			return info2;
		}
		
		value rootModule = getModule(moduleName, moduleVersion);
		value sortedModules = ArrayList<ModuleInfo>();
		
		value todo = HashSet<ModuleInfo>();
		todo.add(rootModule);
		while (exists mod = todo.first) {
			todo.remove(mod);
			sortedModules.add(mod);
			for (dep in mod.dependencies) {
				value depmod = getModule(dep.name, dep.version);
				depmod.uses -= 1;
				if (depmod.uses == 0) {
					todo.add(depmod);
				}
			}
		}
		
		value jsModules = sortedModules.flatMap((mod) => [
					mod.jsName + "-model" -> mod.jsModel.artifact(),
					mod.jsName->mod.js.artifact()
				]);
		
		value sources = jsModules.map((entry) {
				value name = entry.key;
				value file = entry.item;
				value resource = parsePath(file.string).resource;
				assert (is File resource);
				value code = "\n".join(lines(resource));
				return name->code;
			});
		
		value source = "(function() {"
				+ "var modules = {};"
				+ "function require(name) { return modules[name].exports; }"
				+ "\n".join(sources.map((entry) => "(function() {"
							+ "var exports = {};"
							+ "var module = { exports: exports };"
							+ "modules['``entry.key``'] = module;"
							+ entry.item
							+ "}());"))
				+ "require('``rootModule.jsName``').``func``();"
				+ "}());";
		
		return source;
	}
	
	shared void setRepositoryAsStrings(String* reps) {
		setRepository(JavaList(reps.map((rep) => URI(rep)).sequence()));
	}
	
	ArtifactResult getArtifact(String moduleName, String moduleVersion, String suffix) {
		value context = ArtifactContext(moduleName, moduleVersion, suffix);
		return repositoryManager.getArtifactResult(context);
	}
}

shared String pack(String name, String* reps) {
	value packJs = CeylonPackJsTool();
	packJs.setRepositoryAsStrings(*reps);
	return packJs.pack(name);
}

shared void run() {
	value toolClass = javaClass<CeylonPackJsTool>();
	object toolLoader extends CeylonToolLoader(toolClass.classLoader) {
		shared actual String getToolClassName(String toolName) => toolClass.canonicalName;
	}
	value toolModel = toolLoader.loadToolModel<CeylonPackJsTool>("pack-js");
	value arguments = JavaList(process.arguments.map(javaString).sequence());
	value packJs = ToolFactory().bindArguments(toolModel, null, arguments);
	packJs.run();
}
