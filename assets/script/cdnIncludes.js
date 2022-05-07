$(document).ready(function(){
	standards();
});
/*
 <summary>Reads in JSON data from CDN for standards</summary>
 <returns>Nothing</returns>
*/
function standards(){
	var callSite1 = "https://casit.illinoisstate.edu/cdn/includes/standards.json";
	var privateStandards = {
			"cache":  false,
			// Use JSONP to work around cross-site scripting limitations.
			"dataType":  "jsonp",
			"url":  callSite1,
			async: false,
			contentType: "application/json",
			jsonpCallback: "jsonCallback",
			dataType: "jsonp"
		};
	var privateRequest = $.ajax(privateStandards);
		privateRequest.done(function(data){
			var itemSize = data.items.length;
			var copy = data.copy;
			var itemprop = data.itemprop;
			var standardString = "";
			for(var i = 0; i < itemSize; i++){
				var name = data.items[i].name;
				var links = data.items[i].link;
				standardString += '<a href="'+links+'">'+name+'</a>';
				if(i == itemSize - 1){
					standardString += "</p>"
				}else{
					standardString += " " + " | ";
				}
			}
			var output = "<p>";
				output += "&copy; " + copy + " ";
				output += "<span itemprop='brand'>"+itemprop+"</span><br />";
				output += standardString;
			$("#standards").html(output);
		});
}
