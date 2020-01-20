--[[
ReaScript Name: VSTi patch Multisample Generator
Description: takes a selected track (which a VSTi has already been loaded into),
generates a MIDI sequence spanning the keyboard, and records the vsti output thru
that midi sequence. Then it freezes it to audio, slices up the clips, meaning all you have to do is render them with a specific naming convention to be recognized by the sampler.
Effectively, this allows me to create folders with WAV files, each one corresponding
to a key on the keyboard. These can then be opened up and played like a multisampled
instrument.

 
Author: John H. Smith (Xcribe)
Date: January 2020

]]--


--[[// DEBUG //--
function Msg( value )
  if console then
    reaper.ShowConsoleMsg( tostring( value ) .. "\n" )
  end
end]]--

----------------// Vars //------------------------- THESE CAN (AND SHOULD) BE CUSTOMIZED!!!!
sympNoteVals = {24,28,31,35,38,41,45,48,52,55,59,62,65,69,72,76,79,83,86,89,93,96,100,103,107} --Array of notes you wanna sample. ****STILL A WORK IN PROGRESS!!! DON'T USE!!!***
usesFullKbd = true                                      --Instead just leave usesFullKbd as true. This renders the entire keyboard chromatically.

numMeasures = 1  
releaseTimeOff = 960 --(PPQ) The amount of time "cut-off" the end of each note, aka kind of like Release.



----// INIT //----      <----DON'T MESS WITH THESE!
track =  reaper.GetSelectedTrack(0,0)
item ={}
if usesFullKbd == true then
  item =  reaper.CreateNewMIDIItemInProj( track, 0, 2*108*numMeasures, false )
else
  item =  reaper.CreateNewMIDIItemInProj( track, 0, 2*22*numMeasures, false )
end
reaper.Main_OnCommand(40182,0)  --Select all Items
reaper.Main_OnCommand(40153,0)  --Opens MIDIEditor
active_midi_editor = reaper.MIDIEditor_GetActive()
take = reaper.MIDIEditor_GetTake(active_midi_editor)


------------------// FUNCTIONS //-----------------------------------
function MIDIgen(take)

  if usesFullKbd==true then
    for i=1, 108, 1 do
      reaper.MIDI_InsertNote( take, true, false, 3840*i*numMeasures, (3840*i*numMeasures + numMeasures*3840)-releaseTimeOff, 1, i+1, 110, true ) --I NEED TO FIGURE OUT HOW TO OfFSET EACH NOTE BY TWO MEASURES!!! Aka Convert Project Measures -->PPQ!
    end 
  else
    for j=0, 22-1, 1 do
      reaper.MIDI_InsertNote( take, true, false, 3840*j*numMeasures, (3840*j*numMeasures + numMeasures*3840)-releaseTimeOff, 1, sympNoteVals[j+1], 110, true )
    end
  end
  reaper.MIDI_Sort(take)

end

--------------------------------------------//  *** MAIN METHOD ***  //--------------------------------------------
function Main(take) --Controls all the execution steps of the program aka big daddy method
  
  MIDIgen(take)
  
  reaper.Main_OnCommand(41223,0) --Freeze Track to Stereo
  
  if usesFullKbd==true then       --Creates Markers
    for i=1, 108, 1 do
     reaper.SetEditCurPos( 2*i*numMeasures, true, false )
         reaper.Main_OnCommand(40157,0) 
    end
  else
    for j=0, 22-1, 1 do
    reaper.SetEditCurPos( 2*j*numMeasures, true, false )
    reaper.Main_OnCommand(40157,0)
    end
  end
  
 
 
 reaper.Main_OnCommand(40421,0) --selects the media items on selected track
 
 reaper.Main_OnCommand(40576,0) --Toggles Item Lock
 
 reaper.Main_OnCommand(40931,0) --Split Item(s) at Project Markers
 
 if usesFullKbd==true then       --Destroys Markers
     for i=1, 108, 1 do
      reaper.SetEditCurPos( 2*i*numMeasures, true, false )
          reaper.Main_OnCommand(40613,0) 
     end
   else
     for j=0, 22-1, 1 do
     reaper.SetEditCurPos( 2*j*numMeasures, true, false )
     reaper.Main_OnCommand(40613,0)
     end
   end

   reaper.Main_OnCommand(40153,0)
  --reaper.Main_OnCommand(40421,0) --selects the media items on selected track
  reaper.Main_OnCommand(40576,0) --Unlocks current item
  --reaper.Main_OnCommand(40576,0) --Unlocks current item
  
  --********** ADD FADE OUTS / SET FADE TO ZERO HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********************************!!!
  
  --reaper.ClearConsole()
  --reaper.ShowConsoleMsg("Main method executed successfully! :)")
  

end


-----// UNDO ENABLER //------
if take then -- IF MIDI EDITOR
  reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
  Main(take)
  reaper.Undo_EndBlock("VSTi-->.Wav   Builder", 0) -- End of the undo block. Leave it at the bottom of your main function.
end 






