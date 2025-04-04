local headers = {
  [[
                         ,   
  ,-.       _,---._ __  / \  
 /  )    .-'       `./ /   \ 
(  (   ,'            `/    /|
 \  `-"             \'\   / |
  `.              ,  \ \ /  |
   /`.          ,'-`----Y   |
  (            ;        |   '
  |  ,-.    ,-'         |  / 
  |  | (   |            | /  
  )  |  \  `.___________|/   
  `--'   `--'                
  ]],
  [[
      |\      _,,,---,,_     
ZZZzz /,`.-'`'    -.  ;-;;,_ 
     |,4-  ) )-,_. ,\ (  `'-'
    '---''(_/--'  `-'\_)     
  ]],
  [[
              __..--''``---....___   _..._    __         
    /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
   ///_.-' _..--.'_    \                    `( ) ) // // 
   / (_..-' // (< _     ;_..__               ; `' / ///  
    / // // //  `-._,_)' // / ``--...____..-' /// / //   
  ]],
  [[
                \`*-.                    
                 )  _`-.                 
                .  : `. .                
                : _   '  \               
                ; *` _.   `*-._          
                `-.-'          `-.       
                  ;       `       `.     
                  :.       .        \    
                  . \  .   :   .-'   .   
                  '  `+.;  ;  '      :   
                  :  '  |    ;       ;-. 
                  ; '   : :`-:     _.`* ;
         [bug] .*' /  .*' ; .*`- +'  `*' 
               `*-*   `*-*  `*-*'        
  ]],
}

-- Randomly select a header
math.randomseed(os.time())
local random_header = headers[math.random(#headers)]

return {

  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = random_header,
          keys = {
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
}
