function scr_eyet_data(argument0, argument1) {
	var _json = argument0, _str = argument1;
	//trace(_str);
	if (_json == -1) exit;
	var _values = _json[?"values"];
	if (_values == undefined) exit;
	var _frame = _values[?"frame"];
	if (_frame == undefined) exit;
	var _time = _frame[?"time"];
	var _point1 = _frame[?"lefteye"];
	var _point2 = _frame[?"righteye"];
		if (_point1 != undefined) or  (_point2 != undefined) {
		trace(_time, _point1[?"psize"],_point2[?"psize"]);
		gaze_update(_point1[?"psize"],_point2[?"psize"]);
		last_data_time = current_time;
	}
	
		 
}
