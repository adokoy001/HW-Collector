

function send_chardata(canv_w,canv_h) {
    var data_param = 
	"data1="+encodeURIComponent(mytoJSON($("#jsignature_field1").jSignature("getData","native")))
	+"&value="+encodeURIComponent($("#value").val())
	+"&category="+encodeURIComponent($("#category").val())

	+'&width='+canv_w+'&height='+canv_h+'&mode=2';

    jQuery.ajax({
	    type: "POST",
	    cache: false,
	    async: false,
	    url: "/char_learn",
	    data: data_param,
	    success: function(data, status){
		alert(data);
	    },
	    error: function(XMLHttpRequest, status, errorThrown){
		alert("通信障害が発生しました。");
	    }
	});

}


function mytoJSON(tmp){
    var str = '{"lines":[';
    var str_num = '';
    for (var l=0; l<tmp.length;l++ ){
        str_num = str_num+'[';
        for(var i=0;i < tmp[l].x.length;i++){
            str_num = str_num+'['+tmp[l].x[i]+','+tmp[l].y[i]+']';
            if(i+1  == tmp[l].x.length){
                str_num = str_num+']';
            }else{str_num = str_num+',';}
        }
        if(l +1 == tmp.length){
        }else{str_num = str_num + ',';}
    }
    str = str+str_num+']}';
    return(str);
}



function jsig_del(target_field){
    $('#'+target_field).jSignature("clear");
}

