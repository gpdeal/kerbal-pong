// pong graphics library
// This is mainly so that the code isn't cluttered up by line after line of graphics functions


function displayTitle {
  clearscreen.
  print "     ____     ____     ___    __   _____ ".
  print "    / __ \   / _  |   /  |   / /  / ____\".
  print "   / /_/ /  / / / /  /   |  / /  / /     ".
  print "  / /___/  / / / /  / /| | / /  / / ___  ".
  print " / /      / /_/ /  / / | |/ /  / /__/ /  ".
  print "/_/      |_____/  /_/  |___/  |______/   ".
}


function drawBox {
  // top/bottom row
  set i to 5.
  until i = screen_width {
    print "-" at(i, 0).
    print "-" at(i, screen_height - 2).
    set i to i + 1.
  }
  // sides
  set i to 1.
  until i = screen_height - 2 {
    print "|" at(5, i).
    print "|" at(screen_width - 1, i).
    set i to i + 1.
  }
}

function clearBox {
  local i is left_column.
  
  until i = right_column + 1 {
    print " " at(i, top_row).
    print " " at(i, top_row - 1).
    print " " at(i, bottom_row).
    print " " at(i, bottom_row - 1).
    set i to i + 1.
  }
}



function printScores {
  printDigit(playerScore, "player").
  printDigit(cpuScore, "cpu").
}

function printDigit {
  parameter digit, player.
  
  local startRow is 0.
  
  if player = "player" {set startRow to floor((screen_height / 2)) - 7.} 
  else {set startRow to (floor((screen_height + 1) / 2)) + 1.}
  
  if digit = 0 {
    print "** " at(1, startRow).
    print "* *" at(1, startRow + 1).
    print "* *" at(1, startRow + 2).
    print "* *" at(1, startRow + 3).
    print " **" at(1, startRow + 4).
  } else if digit = 1 {
    print " * " at(1, startRow).
    print "** " at(1, startRow + 1).
    print " * " at(1, startRow + 2).
    print " * " at(1, startRow + 3).
    print "***" at(1, startRow + 4).
  } else if digit = 2 {
    print "***" at(1, startRow).
    print "  *" at(1, startRow + 1).
    print " **" at(1, startRow + 2).
    print "*  " at(1, startRow + 3).
    print "***" at(1, startRow + 4).
  } else if digit = 3 {
    print "***" at(1, startRow).
    print "  *" at(1, startRow + 1).
    print " * " at(1, startRow + 2).
    print "  *" at(1, startRow + 3).
    print "***" at(1, startRow + 4).
  } else if digit = 4 {
    print "* *" at(1, startRow).
    print "* *" at(1, startRow + 1).
    print "***" at(1, startRow + 2).
    print "  *" at(1, startRow + 3).
    print "  *" at(1, startRow + 4).
  } else if digit = 5 {
    print "***" at(1, startRow).
    print "*  " at(1, startRow + 1).
    print "** " at(1, startRow + 2).
    print "  *" at(1, startRow + 3).
    print "** " at(1, startRow + 4).
  } else if digit = 6 {
    print " **" at(1, startRow).
    
    print "*  " at(1, startRow + 1).
    print "***" at(1, startRow + 2).
    print "* *" at(1, startRow + 3).
    print " **" at(1, startRow + 4).
  } else if digit = 7 {
    print "***" at(1, startRow).
    print "  *" at(1, startRow + 1).
    print " * " at(1, startRow + 2).
    print "*  " at(1, startRow + 3).
    print "*  " at(1, startRow + 4).
  } else if digit = 8 {
    print "***" at(1, startRow).
    print "* *" at(1, startRow + 1).
    print "***" at(1, startRow + 2).
    print "* *" at(1, startRow + 3).
    print "***" at(1, startRow + 4).
  } else if digit = 9 {
    print " **" at(1, startRow).
    print "* *" at(1, startRow + 1).
    print "***" at(1, startRow + 2).
    print "  *" at(1, startRow + 3).
    print "** " at(1, startRow + 4).
  }
}

function drawStartingPaddles {
  local startingPaddleLoc is floor((((screen_width - 6) / 2) + 5) - (paddle_width / 2)).
  
  local i is startingPaddleLoc.
  until i = startingPaddleLoc + paddle_width {
    print "=" at(i, 1).
    print "=" at(i, screen_height - 3).
    set i to i + 1.
  }
  
  print "o" at(playerPaddleLoc + paddle_width - 1, screen_height - 4).
}

function movePaddle {
  parameter player, paddleLoc, direction.
  
  local paddleLine is 0.
  if player = "player" {set paddleLine to bottom_row.}   //set paddleLine to screen_height - 3.} 
  else if player = "cpu" {set paddleLine to top_row - 1.}
  else{ 
    clearscreen.
    print "You messed up your movePaddle player parameter!".
    local error is 1 / 0.
  }
  
  if direction = "left" {
    if paddleLoc > left_column {
      print " " at(paddleLoc + paddle_width - 1, paddleLine).
      print "=" at(paddleLoc - 1, paddleLine).
    }
  } else if direction = "right" {
    if paddleLoc < right_column - (paddle_width - 1) {
      print " " at(paddleLoc, paddleLine).
      print "=" at(paddleLoc + paddle_width, paddleLine).
    }
  } else {
    clearscreen.
    print "You messed up your movePaddle direction parameter!".
    local error is 1 / 0.
  }
}

function redrawBall {
  parameter ballX,    // ball's current x coordinate
            ballY,    // ball's current y coordinate
            dirVert,  // ball's vertical direction
            dirHor.   // ball's horizontal direction.
  
  local oldX is 0.
  local oldY is 0.
  
  if dirVert = "up" {set oldY to ballY + 1.}
  else if dirVert = "down" {set oldY to ballY - 1.}
  else {
    clearscreen.
    print "You messed up your moveBall direction parameter!".
    local error is 1 / 0.
  }
  
  if dirHor = "left" {set oldX to ballX + 1.}
  else if dirHor = "right" {set oldX to ballX - 1.}
  else {
    clearscreen.
    print "You messed up your moveBall direction parameter!".
    local error is 1 / 0.
  }
  
  print "o" at(ballX, ballY).
  print " " at(oldX, oldY).
}
