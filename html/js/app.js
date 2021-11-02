dollar = {}; 


$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
        dollar.CloseAyarMenu();
            break;
    }
});

dollar.CloseAyarMenu = function() {
    $(".ayar-menu-ana").css({"display":"none"});
    $.post('https://zbLSPD/CloseMenu:NuiCallback',JSON.stringify({data: true}));
};




window.addEventListener('message', function(event) {
    eFunc = event.data
    if (eFunc.action == "showui") {
        $('body').show()
    } else if (eFunc.action == "hideui") {
        $("body").fadeOut(500)
    } else if(eFunc.action == "showMenu") {
        $(".ayar-menu-ana").css({"display":"flex"});
    }
})


$('#market-on').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/livery:1', JSON.stringify({}));
        document.getElementById("benzinlik-on").checked =  0;
        document.getElementById("garaj-on").checked =  0;
        document.getElementById("sapka-on").checked = 0;
    }
    else{
        $.post('https://zbLSPD/livery:-1', JSON.stringify({}));

    }
});


$('#garaj-on').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/livery:2', JSON.stringify({}));
        document.getElementById("market-on").checked =  0;
        document.getElementById("benzinlik-on").checked =  0;

        document.getElementById("sapka-on").checked = 0;
    }
    else{
        $.post('https://zbLSPD/livery:-1', JSON.stringify({}));

    }
});



$('#sapka-on').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/livery:0', JSON.stringify({}));
        document.getElementById("market-on").checked =  0;
        document.getElementById("benzinlik-on").checked =  0;
        document.getElementById("garaj-on").checked =  0;

    }
    else{
        $.post('https://zbLSPD/livery:-1', JSON.stringify({}));

    }
});


$('#benzinlik-on').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/livery:3', JSON.stringify({}));
        document.getElementById("market-on").checked =  0;
        document.getElementById("garaj-on").checked =  0;
        document.getElementById("sapka-on").checked = 0;
    }
    else{
        $.post('https://zbLSPD/livery:-1', JSON.stringify({}));

    }
});

$('#dollar-bagg').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:2', JSON.stringify({}));
        
    }
    else{
        $.post('https://zbLSPD/extra:-2', JSON.stringify({}));  
    }
});


$('#dollar-glass').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:1', JSON.stringify({}));    }
    else{
        $.post('https://zbLSPD/extra:-1', JSON.stringify({}));    }
});
$('#dollar-bracelet').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:4', JSON.stringify({}));
    }
    else{
        $.post('https://zbLSPD/extra:-4', JSON.stringify({}));
    }
});
$('#dollar-gloves').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:3', JSON.stringify({}));
    }
    else{
        $.post('https://zbLSPD/extra:-3', JSON.stringify({}));
    }
});


$('#dollar-watch').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:5', JSON.stringify({}));
    }
    else{
        $.post('https://zbLSPD/extra:-5', JSON.stringify({}));
    }
});


$('#dollar-necklace').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:6', JSON.stringify({}));
    }
    else{
        $.post('https://zbLSPD/extra:-6', JSON.stringify({}));
    }
});



$('#dollar-Earring').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:8', JSON.stringify({}));
    }
    else{
        $.post('https://zbLSPD/extra:-8', JSON.stringify({}));
    }
});

$('#dollar-vest').on('change',function(){
    if(this.checked){
        $.post('https://zbLSPD/extra:7', JSON.stringify({}));
    }
    else{
        $.post('https://zbLSPD/extra:-7', JSON.stringify({}));
    }
});

    




document.querySelector("#aksesuarbatin").onclick = function() {
console.log('test')
    $(".clothing").fadeOut(500);
    $(".aksesuarr").fadeIn(700)
    $("#aksesuarbatin").css({"outline": "none"})
}
document.querySelector("#clothingBatin").onclick = function() {

    $(".aksesuarr").fadeOut(500);
    $(".clothing").fadeIn(700)
    $("#clothingBatin").css({"outline": "none"})
}
