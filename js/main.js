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
              netSpendReply = "<strong>" + value.club +  "</strong> did not spend any money in this summer's transfer window."
            } else if (value.net_spend > 0 && value.net_spend < 1000000) {
                netSpendReply = "<strong>" + value.club +  "</strong> spent <strong>£" + Math.round(value.net_spend/1000000) + " million </strong>in this summer's transfer window."
            } else if (value.net_spend >= 1000000) {
                netSpendReply = "<strong>" + value.club +  "</strong> spent <strong>£" + Math.round(value.net_spend / 1000000) + " million</strong> in this summer's transfer window."
            } else {
                netSpendReply = "<strong>" + value.club +  "</strong> made a profit of <strong>£" + Math.round(Math.abs(value.net_spend / 1000000)) + " million</strong> in this summer's transfer window."
            }
        		
            $("#netSpendDiv").html(netSpendReply);

            var playerNumbersReply = "The club signed a total of " + value.players_in + " players this summer, with " + value.players_out + " players departing.";

            $("#numberOfPlayers").html(playerNumbersReply);

            barChart(selectedTeam);
        	}
  		}); 
	});
} 

function barChart(selectedTeam) {
  $.getJSON('data/player_transfers.json', function(data) { 
    $.each(data, function(key, value) { 
          if (value.club == selectedTeam) {
         console.log(value)
          }
      }); 
  });
} 


