package;
import hxlua.*;
class Main {
   public static function main(){
      var vm:cpp.RawPointer<Lua_State> = LuaL.newstate();
      LuaL.dofile(vm, "events.lua");
   }
}