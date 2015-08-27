 // U3.W7: Design Basic Game Solo Challenge

// This is a solo challenge

// Your mission description:
// Overall mission: Create "Deal or No Deal" In the Console
// Goals: Walk away with as much money as possible
// Characters: The player, who opens cases, and the host/banker, who makes offers
// Objects: Various cases
// Functions: Open a case, display game state, make an offer 

// Pseudocode
// Create a series of cases with different values
// Prompt the player to open a case, and reveal the value
// Make the player an offer based on the remaining values of the unopened cases
// If the player rejects the offer, the game continues and the open/offer cycle repeats
// Play continues until the player accepts the offer, and receives the offered amount, or open all but one case, and receives the value in the remaining case

// Initial Code

// const case_values = [1, 20, 300, 4000, 50000];

// var cases = [];
// var latestOffer;
// // var util = require('util');
// var readline = require('readline');
// var consoleInterface = readline.createInterface({
//   input: process.stdin,
//   output: process.stdout
// });


// // Case constructor function
// var Case = function(dollarValue) {
//   this.dollarValue = dollarValue;
//   this.open = false;
// }

// // Case opener function
// var openCase = function(caseToOpen) {
//   // Add error handling if case is already opened.
//   caseToOpen.open = true;
//   console.log("The opened case contained $" + caseToOpen.dollarValue + ".")
// }

// var checkForGameEnd = function() {
//   var openCases = 0;
//   var closedCases = [];
//   for (i = 0; i < cases.length; i++) {
//     if (cases[i].open) {
//       openCases++
//     } else {
//       closedCases.push(cases[i]);
//     }
//   }
//   if (openCases + 1 >= cases.length) {
//     console.log("This is the last case. You won $" + closedCases[0].dollarValue + "!");
//     process.exit();
//   }
// }

// var makeOffer = function() {
//   sumOfClosedCases = case_values.reduce(
//     function(total, currentNumber){ return total + currentNumber }
//     );
//   casesLeft = cases.length;
//   for (i = 0; i < cases.length; i++) {
//     // unneccessary
//     if (cases[i].open) {
//       sumOfClosedCases -= cases[i].dollarValue;
//       casesLeft--;
//     }
//   }
//   caseMeanValue = sumOfClosedCases / casesLeft;
//   latestOffer = Math.floor(caseMeanValue * 0.8);
//   console.log("The offer is $" + latestOffer + ".");
// }

// var respondToOffer = function() {
//   consoleInterface.question("Will you take the deal? (y/n) ", function(answer) {
//     if (answer == "y") {
//       console.log("You walked away with $" + latestOffer + ". Congratulations!");
//       process.exit();
//     } else {
//       console.log("No deal! Open another case.")
//       // Recursively calls itself, workaround to force synchronicity
//       playGame();
//     }
//   });
// }

// var displayCases = function() {
//   cases.forEach( function(caseToDisplay) {
//     if (caseToDisplay.open) {
//       console.log("The $" + caseToDisplay.dollarValue + " case has been opened.");
//     } else {
//       console.log("The $" + caseToDisplay.dollarValue + " case is still in play.");
//     }
//   });
// }

// // Recursively calls itself through respondToOffer()
// var playGame = function() {
//   randomCase = Math.floor(Math.random()*cases.length);
//   openCase(cases[randomCase]);
//   checkForGameEnd();
//   displayCases();
//   makeOffer();
//   respondToOffer();
// }


// // Construct array of cases and play game
// case_values.forEach( function(caseValue){
//   cases.push(new Case(caseValue));
// });

// playGame();



// Refactored Code
// To Do: create separate array of opened cases, pop cases from closed to opened as the game goes on. Solves many issues, particularly re-selecting 

const OFFER_MODIFIER = 0.8;

var case_values = [];
var closedCases = [];
var openCases = [];
var latestOffer;
var readlineSync = require('readline-sync');

// Case value seeder
// Random values clamped within discrete segments of total range to avoid clumping
var seedCases = function(numberOfCases, maxCaseValue) {
  dollarValueRangeIncrement = maxCaseValue / numberOfCases;
  for (var i = 0; i < numberOfCases; i ++) {
    dollarValueMinimum = dollarValueRangeIncrement * i;
    randomDollarValue = Math.floor(Math.random() * dollarValueRangeIncrement) + dollarValueMinimum + 1; // +1 to avoid $0 cases.
    case_values.push(randomDollarValue);
  }
}

// Case constructor function
var Case = function(dollarValue) {
  this.dollarValue = dollarValue;
}

// Case opener function
var openCase = function(caseToOpen) {
  caseIndex = closedCases.indexOf(caseToOpen);
  if (caseIndex > -1) {
    closedCases.splice(caseIndex,1);
    openCases.push(caseToOpen);
  }
  console.log("This case contained $" + caseToOpen.dollarValue + ".")
}

// Ends game when only one case remains
var checkForGameEnd = function() {
  if (closedCases.length == 1) {
    console.log("There's only one case left. You won $" + closedCases[0].dollarValue + "!");
    process.exit();
  }
}

// Calculates offer based on remaining unopened values
var makeOffer = function() {
  sumOfClosedCases = 0;
  closedCases.forEach( function(caseToAdd) {
    sumOfClosedCases += caseToAdd.dollarValue;
  });
  caseMeanValue = sumOfClosedCases / closedCases.length;
  latestOffer = Math.floor(caseMeanValue * OFFER_MODIFIER);
  console.log("The offer is $" + latestOffer + ".");
}

// Reads user response
// To do: 
var respondToOffer = function() {
  var answer = readlineSync.question('Will you take the deal? (\'y\' to accept) ')
  if (answer == "y") {
      console.log("You walked away with $" + latestOffer + ". Congratulations!");
      process.exit();
  } else {
    console.log("No deal! Opening another case...")
  }
}

var displayCases = function() {
  openCases.forEach( function(caseToDisplay) {
      console.log("The $" + caseToDisplay.dollarValue + " case has been opened.");
    });
  closedCases.forEach( function(caseToDisplay) {
      console.log("The $" + caseToDisplay.dollarValue + " case is still in play.");
    });
}

var playGame = function() {
  displayCases();
  makeOffer();
  respondToOffer();
  randomCase = Math.floor(Math.random()*closedCases.length);
  openCase(closedCases[randomCase]);
  checkForGameEnd();
}


// Construct array of cases and play game
console.log("Welcome to... Let's Make a Case!")
seedCases(5, 1000000);
case_values.forEach( function(caseValue){
  closedCases.push(new Case(caseValue));
});

while (closedCases) {
  playGame();
}


// Reflection
// I demanded of myself that I make the game actually playable in console, which turned out to be a pretty big ask. I greatly miss the functionality offered by Ruby's "gets" method. I tried to enable the actual playing of the game using a while loop, but node's asynchronous nature made that difficult: the loop would run independently of the user input. This lead, incidentally, to about half a dozen force-quits of a terminal stuck in an infinite loop. There are a few modules out there that seem to solve this issue, but not wanting to require any additional installations for this challenge, I eventually solved the problem using recurisve calls between two methods. That solution feels very "code smelly," but it works for an MVP. I did save myself some time by recognizing that letting the player pick a case at the start of the game and choose which cases to open (as in the actual show) were effectively meaningless actions. Not only did this save me time from creating those functions in the MVP, but it also meant I didn't have to hide the values in the individual cases before they were opened, since opening was done totally at random. The only meaningful decision a player makes in the original game is whether to accept or reject the deals, and this version preserves that core activity.
//
//
//
//
//
//
//