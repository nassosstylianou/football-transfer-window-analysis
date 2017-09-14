$(document).ready(function() {          
      $.getJSON('data/data.json', function(data) {
      	$.each(data, function(key, value) {	
      		$('#list').append('<option value="' + value.club + '">' + value.club + '</option>');
  		}); 
	});    
});


function results(selectedTeam) {
	$.getJSON('data/data.json', function(data) { 
		$.each(data, function(key, value) {	
      		if (value.club == selectedTeam) {
      		var netSpendReply;
				
        if (value.net_spend == 0) {
          netSpendReply = value.club + " did not spend any money in this summer's transfer window."
        } else if (value.net_spend > 0 && value.net_spend < 1000000) {
            netSpendReply = value.club + " spent £" + Math.round(value.net_spend) + " in this summer's transfer window."
        } else if (value.net_spend >= 1000000) {
            netSpendReply = value.club + " spent £" + Math.round(value.net_spend / 1000000) + " million in this summer's transfer window."
          } else {
            netSpendReply = "Your club made a profit of £" + Math.round(Math.abs(value.net_spend / 1000000)) + " million in this summer's transfer window."
          }
      		
          $("div").text(netSpendReply);

          var playerNumbersReply = "The club signed a total of " + value.players_in + " players this summer, with " + value.players_out + " players departing.";

          $("#numberOfPlayers").text(playerNumbersReply);
      		}
  		}); 
	});
} 



/*var netSpendReply; 
if (value.net_spend == 0) {
  netSpendReply = value.club + " did not spend any money in this summer's transfer window."
}
 else if (value.net_spend > 0 && value.net_spend < 1000) {
      netSpendReply = value.club + " spent £" + value.net_spend + " in this summer's transfer window."
  }
 else if (value.net_spend >= 1000 && value.net_spend < 1000000) {
      netSpendReply = value.club + " spent £" + value.net_spend / 1000 + " thousand in this summer's transfer window."
  }
  else if (value.net_spend >= 1000000) {
   netSpendReply = value.club + " spent £" + value.net_spend / 1000000 + " million in this summer's transfer window."
              }  

*/
