package com.napkee.exporters
{
	import com.napkee.utils.ComponentParser;
	import com.napkee.utils.StringUtils;
	
	import mx.containers.VBox;
	import mx.controls.RadioButton;
	import mx.controls.Text;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	public class RadioButtonGroupParser extends BasicParser implements IControlParser
	{
		
		public function RadioButtonGroupParser(controlCode:XML,offsetModifier:OffsetModifier)
		{
			super(controlCode,offsetModifier);
            templateName = "radiobuttongroup.xml";
			if (StringUtils.isBlank(control.controlProperties.text)){
				if (control.controlProperties.child("text").length() > 0){
					control.controlProperties.text = "";
				}
				else {
					control.controlProperties.text = "%28o%29%20option%201%20%28selected%29%0A%28%20%29%20option%202%0A-%28%20%29%20option%203%20%28disabled%29-%0A-%28o%29%20option%204%5Cr%28disabled%20and%20selected%29-%0AA%20row%20without%20a%20radio%20button";
				}
			}
		}
		
		public override function getHtml():String
		{
			var cp:ComponentParser = getBaseHtml();
			
			var code:String = "";
			var crumbs:Array = (control.controlProperties.text).split("%0A");
			
			for (var i:int = 0;i<crumbs.length;i++){
				var line:String = StringUtil.trim(unescape(crumbs[i] as String));
				
				var disabled:Boolean = false;
				if (line.charAt(0) == "-" && line.charAt(line.length-1)=="-"){ // disabled
					disabled = true;
					line = line.substr(1,line.length-2);
				}
				/*
				<input id="${id}" type="checkbox" disabled="${disabled}" checked="${checked}" />
				<label for="${id}">${label}</label>
				*/
				
				if (line.indexOf("( )") == 0){ // unselected checkbox
					code += '\t<label for="'+ getComponentID() + 'i' + i +'" class="radio"><input name="'+ getComponentID() +'" id="'+ getComponentID() + 'i' + i +'" type="radio"'+(disabled?' disabled="true"':'')+'/>\n';
					code += '\t'+StringUtils.escapeCharsAndGetHtml(StringUtil.trim(line.substr(3)),true)+'</label>\n\t\n\n';
				}
				else if (line.indexOf("(-)") == 0 || line.indexOf("(o)") == 0 || line.indexOf("(O)") == 0 || line.indexOf("(*)") == 0 || line.indexOf("(X)") == 0 || line.indexOf("(V)") == 0 || line.indexOf("(x)") == 0 || line.indexOf("(v)") == 0){ // selected checkbox
					code += '\t<label for="'+ getComponentID() + 'i' + i +'" class="radio"><input name="'+ getComponentID() +'" id="'+ getComponentID() + 'i' + i +'" type="radio"'+(disabled?' disabled="true"':'')+' checked="true"/>\n';
					code += '\t'+StringUtils.escapeCharsAndGetHtml(StringUtil.trim(line.substr(3)),true)+'</label>\n\t\n\n';
				}
				else { // no checkbox
					code += '\t<span id="'+ getComponentID() + 'i' + i +'">'+StringUtils.escapeCharsAndGetHtml(disabled?("-"+line+"-"):line,true)+'</span>\n\t\n\n';
				}
				
			}
			
			cp.setPlaceHolder("code",code);
			return cp.getParsed();			
		}
		
		public override function getJsDocReady():String
		{
			var cp:ComponentParser = getBaseJsDocReady();
			cp.setPlaceHolder("clickCode",getJsMultipleLinks());
			return cp.getParsed();
		}
		
	}
}