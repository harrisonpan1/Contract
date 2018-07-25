pragma solidity ^0.4.22;
contract IterableMap{
    struct entry {
        // Equal to the index of the key of this item in keys, plus 1.
        uint keyIndex;
        uint value;
    }

    struct itermap {
        mapping(uint => entry) map;
        uint[] keys;
    }
    
    function insert(itermap storage self, uint key, uint value) internal returns (bool replaced) {
        entry storage e = self.map[key];
        e.value = value;
        if (e.keyIndex > 0) {
            return true;
        } else {
            e.keyIndex = self.keys.length + 1;
            self.keys[e.keyIndex - 1] = key;
            return false;
        }
    }
    
    function remove(itermap storage self, uint key) internal returns (bool success){
        entry storage e = self.map[key];
        if(e.keyIndex == 0){
            return false;
        }
        if(e.keyIndex < self.keys.length){
            self.map[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
            self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
            self.keys.length -= 1;
            delete self.map[key];
            return true;
        }
    }
    
    function getAllKeys(itermap storage self) internal constant returns (uint[]) {
        return self.keys;
    }
    
    function getKey(itermap storage self, uint key) internal constant returns (uint) {
        return self.keys[key];
    }
    
    function getValue(itermap storage self, uint key) internal constant returns (uint) {
        return self.map[key].value;
    }
    
    function size(itermap storage self) internal constant returns (uint) {
        return self.keys.length;
    }

 }
