function formatTime(millis) {
  var seconds = Math.round(millis / 1000);

	var minutes = Math.floor(seconds / 60);
  seconds = seconds - (minutes * 60);

  var hours = Math.floor(minutes / 60);
  minutes = minutes - (hours * 60);

  var days = Math.floor(hours / 24);
  hours = hours - (days * 24);

  var str = "";

  if (days > 0) {
  	str = str + days + ":";
  }
  if (hours > 0) {
  	if (hours < 10 && str !== "")
    	str = str + "0";
    str = str + hours + ":";
  }
  if (minutes < 10 && str !== "") {
  	str = str + "0";
  }
  str = str + minutes + ":";
  if (seconds < 10) {
  	str = str + "0";
  }
  str = str + seconds;
  return str;
}

$(document).on("click", ".countdown-timer-start", function(e) {
  var timerEl = $(e.target).parent(".countdown-timer");
	var remaining = timerEl.data("countdown-timer-time");
  if (typeof(remaining) == "undefined" || remaining === null) {
  	remaining = +timerEl.data("timespan") * 1000;
  }
  var stop = new Date().getTime() + remaining;

  var handle = setInterval(function() {
  	var left = Math.max(0, stop - new Date().getTime());
  	timerEl.data("countdown-timer-time", left);
  	timerEl.trigger("countdown:time", {left: left / 1000});
    timerEl.find(".countdown-timer-time").text(formatTime(left));
    if (left === 0) {
    	clearInterval(handle);
		  timerEl.removeClass("active");
    }
  }, 1000);
  timerEl.data("countdown-timer-handle", handle);
  timerEl.addClass("active");
});
$(document).on("click", ".countdown-timer-stop", function(e) {
  var timerEl = $(e.target).parent(".countdown-timer");
  clearInterval(timerEl.data("countdown-timer-handle"));
  timerEl.removeClass("active");
});
$(document).on("click", ".countdown-timer-reset", function(e) {
  var timerEl = $(e.target).parent(".countdown-timer");
  timerEl.find(".countdown-timer-stop").click();
	var left = +timerEl.data("timespan") * 1000;
  timerEl.data("countdown-timer-time", left);
  timerEl.find(".countdown-timer-time").text(formatTime(left));
});
