$(".question-choice").on("click", function(){
  $(".question-choice").removeClass("selected");
  $(this).addClass("selected");
});

$(".question-choice").change(function(){
  $("button.btn-next-question").addClass("visible");
})

