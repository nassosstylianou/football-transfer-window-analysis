$(document).ready(function() {          
      $.getJSON('new_data.json', function(data) {
      	$.each(data, function(key, value) {	
      		$('#list').append('<option value="' + value.club + '">' + value.club + '</option>');
  		}); 
	});    
});


function results(selectedTeam) {
	$.getJSON('new_data.json', function(data) { 
		$.each(data, function(key, value) {	
      		if (value.club == selectedTeam) {
      		var netSpendReply;
				if (value.net_spend > 0) {
               netSpendReply =    "Your club spent £" + value.net_spend / 1000000 + " million in this summer's transfer window. They signed a total of " + value.players_in + " players this summer, with " + value.players_out + " players leaving the club." 
              }    else {
                 netSpendReply =   "Your club made a profit of £" + Math.abs(value.net_spend / 1000000) + " million in this summer's transfer window."
              }
      			$("div").text(netSpendReply);
      		}
  		}); 
	});
} 
