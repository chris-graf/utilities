### HS Arena Simulator

A Ruby script that simulates 'Arena' drafts in the online card game 'Hearthstone'.

### Drafting in brief
An 'Arena' draft goes as follows:
* The player selects one of nine 'hero classes' to play for the duration of the arena.
  * Their class selection restricts which cards are available to them.
  * The player does not have full control over their choice of hero class, but will be a random set of three classes from which to make their final selection.
* The player is then offered a choice of three cards chosen from all those they may legally use given their hero class choice. The player selects one card of the three to add to their deck.
* This three-cards-choose-one process is iterated 30 times, at the end of which the player has a deck of 30 cards.
* The player proceeds to play other 'Arena' participants with their deck until they reach a particular number of wins or losses.

### Script Use
This script compiles ratings for each class/card combination in the game as of approximately August 13th 2015, as calculated by fansite Heartharena.com. These ratings represent the expected value of each class/card item. Higher ratings are better.

For each hero class, the script randomizes a large number of drafts and chooses cards according to the Heartharena ratings, then prints aggregate statistics:
* avg score: the mean rating of all cards in all decks
* avg card sd: the mean standard deviation of card ratings within a deck
* deck sd: the standard deviation of 'avg score'

### How to Run
Navigate to the directory in your terminal, and execute `ruby simulator.rb`

