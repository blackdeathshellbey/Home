/* auxiliary rules for agents */

i_am_winning(Art)   // check if I placed the current best bid on auction artifact Art
   :- currentWinner(W)[artifact_id(Art)] &
      .my_name(Me) & .term2string(Me,MeS) & W == MeS.

/* auxiliary plans for Cartago */

+!start : true
               <- for ( my_task(Task) ) {
                      .concat("auction_for_",Task,Result);
                      // .print("discovering ",Result);
                      !discover_art(Result);
                      };
                  .

// try to find a particular artifact and then focus on it
+!discover_art(ToolName)
   <- lookupArtifact(ToolName,ToolId);
      focus(ToolId).
// keep trying until the artifact is found
-!discover_art(ToolName)
   <- .wait(100);
      !discover_art(ToolName).
+won(Winner,Task)
  <- .tell(winner(Winner,Task));
    println("Agent ",Winner," has won task ",Task);
    // Filter the shared information to exclude the agent's own winning task
    rd(winner(OtherWinner,OtherTask));
    if (Winner == OtherWinner) then
        println("Excluding my own task: ", OtherTask)
    else
        println("Other winning task: ", OtherTask)
    .
