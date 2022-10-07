$(document).ready(function(){
	var check=0;
	$('input[type=file]').change(function(event){
			var inputfile= $(this).val().split('\\');
			var filename= inputfile[inputfile.length-1];
			console.log(filename);
			var pattern = /(gif|jpg|jpeg|png)$/i; //i(ignore case) 대소문자 무시
			
			if(pattern.test(filename)){
				$("#filevalue").text(filename);//inputfile.length - 1=2
				var reader = new FileReader();//파일을 읽기위한 객체 생성
				//DataURL형식(접두사 data:가 붙은 URL이며 바이너리 파일을 Base64로 인코딩하여 ASCII문자열 형식으로 변환한 것)으로
				//파일을 읽어온다. (참고-BASE64가 붙은 인코딩은 바이너리 데이터를 Text로 변경하는 Encoding이다.)
				//네트워크탭에서 실행 후 Headers 확인
				
				//읽어온 결과는 reader객체의 result 속성에 저장된다.
				//event.target.files[0] : 선택한 그림의 파일객체에서 첫번째 객체를 가져온다.
				reader.readAsDataURL(event.target.files[0]);
			}else{
				alert('이미지 파일(gif,jpg,jpge,png)만 첨부 가능합니다.');
				$('#filevalue').text('');
				$(this).val('');
			}
		})
	function show(){
		//파일 이름이 있는 경우 remove 이미지를 보이게하고
		//파일 이름이 없는 경우 remove 이미지 보이지 않게 함
		if($("#filevalue").text()==''){
			$(".remove").css('display','none');
		}else{
			$(".remove").css({'display':'inline-block',
								'position':'relative','top':'-5px'})
		}
	}
	show();
	
	$(".remove").click(function(){
		$("#filevalue").text('');
		$(this).css('display','none');
	})
	
	
	$("#upfile").change(function(){
		check++;//변경하면 체크값 증가 , 안하는 경우 check는 0이 된다.
		var inputfile = $(this).val().split('\\');
		$("#filevalue").text(inputfile[inputfile.length-1]);
		show();
		console.log(check);
		console.log($('#filevalue').text());
	});
	
	
	$("form").submit(function(){
		
		if($.trim($("#review_pass").val())==""){
			alert("비밀번호를 입력하세요");
			$("#review_pass").focus();
			return false;
		}

		if($.trim($("#review_subject").val())==""){
			alert("제목을 입력하세요");
			$("#review_subject").focus();
			return false;
		}
		
		if($.trim($("#review_content").val())==""){
			alert("내용을 입력하세요");
			$("#review_content").focus();
			return false;
		}
		
		//파일 첨부를 변경하지 않으면 $('#filevalue').text()의 파일명을
		//파라미터 'check'라는 이름으로 form에 추가하여 전송한다.
		if(check==0){
			value=$('#filevalue').text();
			html="<input type='hidden' value='"+value+"' name='check'>";
			$(this).append(html);
			console.log(html);
		}
		
	})
	
})
