namespace Boojay.Compilation.Steps

import Boo.Lang.Compiler
import Boo.Lang.Compiler.TypeSystem
import Boo.Lang.Compiler.Ast
import Boo.Lang.PatternMatching

def resolveRuntimeMethod(methodName as string):
	return resolveMethod(typeSystem().RuntimeServicesType, methodName)
	
def resolveMethod(type as IType, name as string):
	return nameResolutionService().ResolveMethod(type, name)
	
def bindingFor(node as Node):
	return typeSystem().GetEntity(node)
	
def erasureFor(type as IType):
	if type isa IGenericParameter:
		return typeSystem().ObjectType
	return type

def typeOf(e as Expression):
	match e:
		case [| null |]:
			return Null.Default
		otherwise:
			return typeSystem().GetExpressionType(e)
	
def typeSystem():
	return context().TypeSystemServices
	
def nameResolutionService():
	return context().NameResolutionService
	
def context():
	return CompilerContext.Current
	
def uniqueName():
	return "$" + context().AllocIndex()
	
def uniqueReference():
	return ReferenceExpression(uniqueName())
		