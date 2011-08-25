$.extend({
	"put" : function (url, data, success, type) {
		return $.ajax({
			"url" : url,
			"data" : data,
			"success" : success,
			"type" : "PUT",
			"cache" : false,
			"dataType" : type
		});
	},
	"del" : function (url, data, success, type) { 
		return $.ajax({
			"url" : url,
			"data" : data,
			"success" : success,
			"type" : "DELETE",
			"cache" : false,
			"dataType" : type
		});
	}
});

String.prototype.escape_html = function(){
    var span = document.createElement('span');
    var txt =  document.createTextNode('');
    span.appendChild(txt);
    txt.data = this;
    return span.innerHTML;
};
