package state;

class Test {
	private var value:String = null;
	
	public function new(value:String) {
		this.value = value;
	}

	public function return_value() {
		return this.value;
	}
}