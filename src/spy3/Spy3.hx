import hxlua.Types;
import hxlua.LuaL;
import hxlua.Lua;
class Spy3 {
   private var vm:cpp.RawPointer<Lua_State> = LuaL.newstate();
   private var fileStat:Int;

   public function new() {
      fileStat = LuaL.loadfile(vm, "events.lua");
   }

   public function run(logicFunc: cpp.RawPointer<cpp.Void>): Void {
      if (fileStat != 0) {
          // Push the 'on_update' function onto the Lua stack
          hxlua.Lua.getglobal(vm, "on_update");
          if (hxlua.Lua.isfunction(vm, -1) == 1) {
              // Create a Lua closure that captures the 'logicFunc' function from Haxe
              hxlua.Lua.pushlightuserdata(vm, logicFunc);
              hxlua.Lua.pushcclosure(vm, function(L:cpp.RawPointer<hxlua.Types.Lua_State>): Lua_CFunction {
                  // Retrieve the 'logicFunc' from the Lua closure
                  var logicFunc: Dynamic = hxlua.Lua.touserdata(vm, hxlua.Lua.upvalueindex(1));
  
                  // Call the 'logicFunc' function from Haxe
                  logicFunc();
                  return cpp.Callable<vm -> 0>;
              }, 1);
  
              // Set the Lua closure as the 'logicFunc' parameter for 'on_update'
              hxlua.Lua.setglobal(vm, "logicFunc");
  
              // Call the 'on_update' function
              if (hxlua.Lua.pcall(vm, 0, 0, 0) != 0) {
                  trace("Error executing 'on_update' function: " + hxlua.Lua.tostring(vm, -1));
              }
          } else {
              trace("'on_update' function not found in Lua script.");
          }
      }
  }
  
   


   public function endRun():Void {
      vm = null;
   }
}
