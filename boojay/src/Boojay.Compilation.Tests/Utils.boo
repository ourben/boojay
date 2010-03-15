namespace Boojay.Compilation.Tests

import System
import System.IO

import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

import Boojay.Compilation
import Boojay.Compilation.TypeSystem

def generateTempJarWith(code as Module):
	jar = Path.GetTempFileName()
	boojayCompile(CompileUnit(code))
	generateJar(jar, "${type.FullName.Replace('.', '/')}.class" for type in code.Members)
	
	return jar

def boojayCompile(unit as CompileUnit):
	boojayCompile(unit, List[of CompileUnit]())

def boojayCompile(unit as CompileUnit, jars as List[of CompileUnit]):
	compiler = newBoojayCompiler()
	result = compiler.Run(unit)
	assert 0 == len(result.Errors), result.Errors.ToString(true) + unit.ToCodeString()

def booCompile(unit as CompileUnit):
	booCompile(unit, List[of CompileUnit]())

def booCompile(unit as CompileUnit, refs as List[of CompileUnit]):
	compiler = newBooCompiler()
	result = compiler.Run(unit)
	assert 0 == len(result.Errors), result.Errors.ToString(true) + unit.ToCodeString()

def newBooCompiler():
	compiler = BooCompiler(CompilerParameters(true))
	compiler.Parameters.OutputType = CompilerOutputType.Auto
	compiler.Parameters.Pipeline = Boo.Lang.Compiler.Pipelines.CompileToMemory()

	return compiler

def runTestWithJar(test as Module, jar as Module):
	generatedJar = generateTempJarWith(jar)
	jarCompileUnit = JarTypeSystemProvider().ForJar(generatedJar)

	boojayCompile(CompileUnit(test), List[of CompileUnit](jarCompileUnit))

