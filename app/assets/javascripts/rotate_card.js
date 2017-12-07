$(function(){
  $("#reportBugAction").tooltip(),
  // $(".slide-action").click(toggleAnswer),
  $(document).on("click", ".flip-button", flipCard),
  // $(document).on("submit", ".form-red", submitNotMasteredCard),
  // $(document).on("submit", ".form-green", submitMasteredCard),
  $(window).keydown(function(t) {
      $(".issue-modal").hasClass("show") || (t.altKey && 13 === t.keyCode ? flipCard() : $("#user-guess-text-area").is(":focus") || 32 !== t.keyCode ? $(".bookmark-action").is(":visible") && 66 === t.keyCode ? $(".bookmark-action").click() : $("#played-card-submit").is(":visible") && 37 === t.keyCode ? $(".form-red").submit() : $("#played-card-submit").is(":visible") && 39 === t.keyCode && $(".form-green").submit() : flipCard())
  });
});

function flipCard() {
  var flashcard = $("#flashcard"),
  answer = flashcard.find("#user-guess-text-area").val();
  return !answer || /^\s*$/.test(answer) ? void $("#user-guess-text-area").effect("shake") : ($("[data-toggle=tooltip], #reportBugAction").tooltip("hide"),
  flashcard.toggleClass("flipped"),
  void setTimeout(function() {
    flashcard.find(".flashcard-game-card-back, .flashcard-game-card-front").toggleClass("invisible"),
    flashcard.find("#user-guess-render").text(answer),
    $("input[name='played_card[guess]']").val(answer)
  }, 100))
};


