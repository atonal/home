import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.InsertPosition
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.ThreeColumns
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ICCCMFocus
import XMonad.StackSet hiding (workspaces)
import XMonad.Actions.SpawnOn
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.RunOrRaise
import Data.Monoid

myModMask = mod1Mask  -- rebind Mod to Super key
myTerminal = "urxvt"
myTerminalBig = "xterm -fs 25"
myBorderWidth = 2
myWorkspaces = [ "1"
               , "2"
               , "3"
               , "4"
               , "5"
               , "6"
               , "7"
               , "8"
               , "9"
               , "0"
               , "+" ]

myLayoutHook = onWorkspace "1" tallLayout
             $ onWorkspace "2" tallLayout
             $ onWorkspace "3" tallLayout
             $ onWorkspace "4" tallLayout
             $ onWorkspace "5" tallLayout
             $ onWorkspace "6" tallLayout
             $ onWorkspace "7" tallLayout
             $ onWorkspace "8" fullLayout
             $ onWorkspace "9" fullLayout
             $ onWorkspace "0" gridLayout
             $ onWorkspace "+" tallLayout
             $ layouts
        where layouts = smartBorders $ avoidStruts $ (layoutHook defaultConfig)
              tallLayout = smartBorders $ avoidStruts (Tall 1 (3/100) (1/2) ||| Full)
              gridLayout = smartBorders $ avoidStruts (Grid ||| Full)
              threeColLayout = smartBorders $ avoidStruts (ThreeCol 1 (3/100) (1/2) ||| Full)
              fullLayout = smartBorders $ noBorders Full

myManageHook = myFloats <+> (composeAll
    [isFullscreen                   --> doFullFloat
    , className =? "Firefox"        --> doShift "1"
    , className =? "Thunderbird"    --> doShift "2"
    , className =? "Spotify"        --> doShift "0"
    , className =? "VirtualBox"     --> doShift "9"
    , className =? "Pidgin"         --> doShift "+"
    , title     =? "xterm_3"        --> doShift "3"
    , title     =? "xterm_4"        --> doShift "4"
    , title     =? "xterm_5"        --> doShift "5"
    ]) <+> manageHook defaultConfig

myFloats = composeOne
    [className  =? "XCalc"      -?> doCenterFloat
    , className =? "Gedit"      -?> doCenterFloat
    , className =? "Xmessage"   -?> doCenterFloat
    , className =? "Zenity"     -?> doCenterFloat
    , className =? "feh"        -?> doCenterFloat
    , title     =? "Save As..." -?> doCenterFloat
    , title     =? "Save File"  -?> doCenterFloat
    , title     =? "Microsoft Teams Notification"  -?> doCenterFloatNoFocus
    , return True               -?> insertPosition Above Newer
    ]

doCenterFloatNoFocus = composeAll [doCenterFloat, insertPosition Above Older]

myLogHook xmproc = dynamicLogWithPP $ xmobarPP {
                     ppOutput = hPutStrLn xmproc
                   , ppTitle = xmobarColor lightTextColor ""
                   , ppCurrent = xmobarColor focusColor ""
                   , ppVisible = xmobarColor lightTextColor ""
                   , ppHiddenNoWindows = xmobarColor lightBackgroundColor ""
                   , ppUrgent = xmobarColor myUrgentColor ""
                   , ppSep = " :: "
                   , ppWsSep = " "
                   }

focusColor = "#EEEEFF"
textColor = "#0A34BF"
lightTextColor = "#A6A6D1"
backgroundColor = "#5071DE"
lightBackgroundColor = "#241D40"
myUrgentColor = "#ffc000"
myFocusedBorderColor = "#FF0000"

myKeys =
    [ ((myModMask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "scrot -s")
    , ((0, xK_Print), spawn "scrot")
    , ((myModMask .|. shiftMask, xK_s), sendMessage ToggleStruts)
    , ((myModMask .|. shiftMask, xK_f), fullFloatFocused)
    , ((myModMask, xK_p), spawn "dmenu_run -i -fn \'-*-fixed-*-*-*-20-*-*-*-*-*-iso8859-15\'")
    , ((myModMask .|. shiftMask, xK_t), spawn myTerminalBig)
    , ((myModMask .|. shiftMask, xK_b), spawn "ncmpcpp-status")
    , ((myModMask .|. shiftMask, xK_n), spawn "ncmpcpp pause")
    , ((myModMask .|. shiftMask, xK_m), spawn "ncmpcpp play")
    , ((myModMask .|. shiftMask, xK_comma), spawn "ncmpcpp prev")
    , ((myModMask .|. shiftMask, xK_period), spawn "ncmpcpp next")
    , ((myModMask .|. controlMask, xK_x), runOrRaisePrompt myXPConfig)
    , ((myModMask, xK_F1), manPrompt myXPConfig)
    , ((myModMask, xK_g), goToSelected defaultGSConfig)
    , ((0, 0x1008FF11), spawn "amixer -D pulse set Master 5%-") -- XF86XK_AudioLowerVolume
    , ((0, 0x1008FF13), spawn "amixer -D pulse set Master 5%+") -- XF86XK_AudioRaiseVolume
    , ((0, 0x1008FF12), spawn "amixer -D pulse set Master toggle && amixer -D pulse set PCM unmute") -- XF86XK_AudioMute
    -- , ((myModMask, xK_c), kill) -- Close window
    , ((myModMask,                 xK_u), prevWS)
    , ((myModMask,                 xK_i), nextWS)
    , ((myModMask .|. controlMask, xK_u), shiftToPrev)
    , ((myModMask .|. controlMask, xK_i), shiftToNext)
    , ((myModMask .|. shiftMask,   xK_u), shiftToPrev >> prevWS)
    , ((myModMask .|. shiftMask,   xK_i), shiftToNext >> nextWS)
    , ((myModMask,                 xK_o), nextScreen)
    , ((myModMask,                 xK_y), prevScreen)
    , ((myModMask .|. controlMask, xK_o), shiftNextScreen)
    , ((myModMask .|. controlMask, xK_y), shiftPrevScreen)
    , ((myModMask .|. shiftMask,   xK_o), shiftNextScreen >> nextScreen)
    , ((myModMask .|. shiftMask,   xK_y), shiftPrevScreen >> prevScreen)
    , ((myModMask .|. shiftMask .|. controlMask, xK_o), swapNextScreen)
    , ((myModMask .|. shiftMask .|. controlMask, xK_y), swapPrevScreen)
    , ((myModMask,                 xK_z), toggleWS)
    ]
    ++
    [((m .|. myModMask, k), windows $ f i)
    | (i, k) <- zip myWorkspaces [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_plus]
    , (f, m) <- [(greedyView, 0), (shift, shiftMask)]]

myXPConfig = defaultXPConfig {
      font = "xft: inconsolata-14"
    , position = Top
    , promptBorderWidth = 0
}

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar"
  xmonad $ docks $ defaultConfig {
               terminal = myTerminal
             , manageHook = myManageHook
             , layoutHook = myLayoutHook
             , borderWidth = myBorderWidth
             , focusedBorderColor = myFocusedBorderColor
             , modMask = myModMask
             , logHook = myLogHook xmproc >> ewmhDesktopsLogHook >> setWMName "LG3D" >> takeTopFocus
             --, startupHook = setWMName "LG3D" -- Fix Java programs
             , workspaces = myWorkspaces
             } `additionalKeys` myKeys

fullFloatFocused =
    withFocused $ \f -> windows =<< appEndo `fmap` runQuery doFullFloat f
