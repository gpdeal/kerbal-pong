// pong

copy lib_pong_graphics from 0.
run lib_pong_graphics.

set screen_width to 41.
set screen_height to 30.
set time_interval to 0.1.
set paddle_width to 8.
set bottom_row to screen_height - 3.
set top_row to 2.
set left_column to 6.
set right_column to screen_width - 2.

clearscreen.
set terminal:width to screen_width.
set terminal:height to screen_height.



function cpuMove {
  parameter ballX, cpuPaddleLoc.
  
  set cpuCenter to cpuPaddleLoc + floor(paddle_width / 2).
  
  if cpuCenter > ballX {
    movePaddle("cpu", cpuPaddleLoc, "left").
    set cpuPaddleLoc to max(left_column, cpuPaddleLoc - 1).
  }
  else if cpuCenter < ballX {
    movePaddle("cpu", cpuPaddleLoc, "right").    
    set cpuPaddleLoc to min(right_column, cpuPaddleLoc + 1).
  }
  
  return cpuPaddleLoc.
}


displayTitle().
set go to false.
on ag5 {set go to true.}

until go {
  print "Press 5 to start!" at(0, 7).
  wait 0.5.
  print "                 " at(0, 7).
  wait 0.5.
}
clearscreen.

// control action groups

on ag5 {
  movePaddle("player", playerPaddleLoc, "left").
  set playerPaddleLoc to max(left_column, playerPaddleLoc - 1).
  
  // keep ball stuck to paddle if have not served yet
  if not served {
    print " " at(playerPaddleLoc + paddle_width, bottom_row - 1).
    print "o" at(playerPaddleLoc + paddle_width - 1, bottom_row - 1).
  }
  preserve.
}

on ag6 {

  movePaddle("player", playerPaddleLoc, "right").
  set playerPaddleLoc to min(right_column - (paddle_width - 1), playerPaddleLoc + 1).
  
  // keep ball stuck to paddle if have not served yet
  if not served {
    print " " at(playerPaddleLoc + paddle_width - 2, bottom_row - 1).
    print "o" at(playerPaddleLoc + paddle_width - 1, bottom_row - 1).
  }
  preserve.
}


set playerScore to 0.
set cpuScore to 0.
drawBox().




set done to false.
on ag9 {set done to true. preserve.}


set gameOver to false.
set winner to "".

until gameOver or done{
  printScores().
  
  // start new round
  // starting location is center of playing field minus half of paddle width
  set playerPaddleLoc to floor(left_column + ((right_column - left_column) / 2) - (paddle_width / 2)).
  set cpuPaddleLoc to floor(left_column + ((right_column - left_column) / 2) - (paddle_width / 2)).
  clearBox().
  drawStartingPaddles().
  // wait for serve
  set served to false.
  on ag3 {set served to true. preserve.}
  wait until served.
  // set ball launch position
  set ballX to playerPaddleLoc + (paddle_width - 1).
  set ballY to bottom_row - 1.
  set dirVert to "up".
  set dirHor to "right".
  set pointScored to false.
  
  // play until point is scored
  until pointScored or done {
    printScores().
    
    // check if ball is about to hit a wall and, if so, change direction
    if dirHor = "right" {
      if ballX = right_column {
        set dirHor to "left".
        set ballX to ballX - 1.
      } else {
        set ballX to ballX + 1.
      }
    } else if dirHor = "left" {
      if ballX = left_column {
        set dirHor to "right".
        set ballX to ballX + 1.
      } else {
        set ballX to ballX - 1.
      }
    }
    // check if ball is about to hit a paddle and, if so, change direction
    if dirVert = "up" {
      if ballY = top_row {
        // if paddle, change direction
        if (ballX >= cpuPaddleLoc) and (ballX <= cpuPaddleLoc + (paddle_width - 1)) {
          set dirVert to "down".
          set ballY to ballY + 1.
        } else {
          set playerScore to playerScore + 1.
          
          set pointScored to true.
        }
      } else {
        set ballY to ballY - 1.
      }
    } else if dirVert = "down"{
      if ballY = bottom_row - 1 {
        // if paddle, change direction
        if (ballX >= playerPaddleLoc) and (ballX <= playerPaddleLoc + (paddle_width - 1)) {
          set dirVert to "up".
          set ballY to ballY - 1.
        } else {
          set cpuScore to cpuScore + 1.
          set pointScored to true.
        }
      } else {
        set ballY to ballY + 1.
      }
    }
    
    redrawBall(ballX, ballY, dirVert, dirHor).
    
    wait time_interval / 2.
    set cpuPaddleLoc to cpuMove(ballX, cpuPaddleLoc).
    wait time_interval / 2.
  }
  
  if playerScore = 10 {set winner to "player". set gameOver to true.}
  if cpuScore = 10 {set winner to "cpu". set gameOver to true.}
}

clearscreen.

print "Winner is: " + winner.
