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
