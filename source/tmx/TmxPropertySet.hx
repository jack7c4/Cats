/*******************************************************************************
 * Copyright (c) 2012 by Adrien Fischer (original by Matt Tuttle based on Thomas Jahn's )
 * This content is released under the MIT License.
 * For questions mail me at adrien@revolugame.com
 ******************************************************************************/
package tmx;

import haxe.xml.Fast;

class TmxPropertySet implements Dynamic<String>
{
	
	public function new()
	{
		data = new Map<String,String>();
	}
	
	public function resolve(name:String):String
	{
		return data.get(name);
	}
	
	public function extend(source:Fast)
	{
		var prop:Fast;
		for (prop in source.nodes.property)
		{
			data.set(prop.att.name, prop.att.value);
		}
	}
	
	public var data:Map<String,String>;
}
