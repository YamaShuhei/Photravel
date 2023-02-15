/*global $*/

// サインアップ用
if (document.URL.match(/sign_up/)){
  // プレビュー画像表示用
  document.addEventListener('DOMContentLoaded', () => {
      const createImageHTML = (blob) => {  
      const imageElement = document.getElementById('img-prev'); 
      const blobImage = document.createElement('img'); 
      blobImage.setAttribute('class', 'new-img');
      blobImage.setAttribute('src', blob); 
      imageElement.appendChild(blobImage);
    }; 
    document.getElementById('user_profile_image').addEventListener('change', (e) =>{
      const imageContent = document.querySelector('img'); 
      if (imageContent){ 
        imageContent.remove(); 
      }
      
      const file = e.target.files[0];  
      const blob = window.URL.createObjectURL(file); 
      createImageHTML(blob); 
    });
  });
  
  // 枠外クリックで非表示に
  $(document).on('click', function(e) {
	//クリックされた場所の判定
	if(!$(e.target).closest('.profileMenu').length && !$(e.target).closest('#next-btn').length){
		$('.profileMenu-back').fadeOut();
	}else if($(e.target).closest('#next-btn').length){
		// ３．ポップアップの表示状態の判定
		if($('.profileMenu-back').is(':hidden')){
			$('.profileMenu-back').fadeIn();
		}else{
			$('.profileMenu-back').fadeOut();
		}
	}else if($(e.target).closest('#close-btn').length){
		if($('.profileMenu-back').is(':visible')){
			$('.profileMenu-back').fadeOut();
		}
	}
});
}