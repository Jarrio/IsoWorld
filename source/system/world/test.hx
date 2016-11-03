    public function SeperateY(a:Body, b:Body, overlapOnly:Bool):Bool {
        if(a.immovable && b.immovable) return false;

        this.overlap = 0;

        if (this.intersects(a, b)) {
            // this.max_overlap = Math.abs(a.delta_z) + Math.abs(b.delta_z) + this.overlap_bias;
            this.max_overlap = a.abs_delta_z + b.abs_delta_z + this.overlap_bias;

            if (a.delta_z == 0 && b.delta_z == 0) {
                a.implanted = true;
                b.implanted = true;                
            } else if (a.delta_z > b.delta_z) {
                this.overlap = (a.top - b.z) - a.width_y;
                           
                if ((this.overlap > this.max_overlap) || a.check_collision.top == false || b.check_collision.z == false) {                  
                    this.overlap = 0;
                } else {
                    // trace('(A>B) | max: ${this.max_overlap} | ${this.overlap}');

                    a.touching.none = false;
                    a.touching.z = true;
                    a.current_overlap = CollideSide.z;  

                    b.touching.none = false;
                    b.touching.top = true;      
                    b.current_overlap = CollideSide.top; 
                }

                // trace('0 - (A>B) | max: ${this.max_overlap} | ${this.overlap}');                     
            } else if (a.delta_z < b.delta_z) {
                this.overlap = (b.top - a.z) - b.width_y;
                
                if ((-this.overlap > this.max_overlap) || a.check_collision.z == false || b.check_collision.top == false) {
                    this.overlap = 0;
                } else {
                    // trace('1 - (A<B) | max: ${this.max_overlap} | ${-this.overlap}');                                     

                    a.touching.none = false;
                    a.touching.top = true;
                    a.current_overlap = CollideSide.top; 

                    b.touching.none = false;
                    b.touching.z = true;
                    b.current_overlap = CollideSide.z;             
                }

                // trace('End - (A<B) | max: ${this.max_overlap} | ${this.overlap}');
            }
        }

        if (this.overlap != 0) {           
            a.overlap_y = this.overlap;
            b.overlap_y = this.overlap;

            if (overlapOnly) {
                return true;
            }

            this.a_overlap_velocity = a.velocity.z;
            this.b_overlap_velocity = b.velocity.z;

            if (!a.immovable && !b.immovable) {
                this.overlap *= 0.5;

                a.z = a.z - this.overlap;
                b.z += this.overlap;

                this.new_velocity_a = (this.b_overlap_velocity * this.b_overlap_velocity * b.weight) / a.weight * ((this.b_overlap_velocity > 0) ? 1 : -1);
                this.new_velocity_b = (this.a_overlap_velocity * this.a_overlap_velocity * a.weight) / b.weight * ((this.a_overlap_velocity > 0) ? 1 : -1);
                this.average = (this.new_velocity_a + new_velocity_b) * 0.5;
                
                this.new_velocity_a -= this.average;
                this.new_velocity_b -= this.average;

                a.velocity.z = FlxMath.roundDecimal(this.average + this.new_velocity_a * a.bounce.z, this.decimal);
                b.velocity.z = FlxMath.roundDecimal(this.average + this.new_velocity_b * b.bounce.z, this.decimal);                
            } else if (!a.immovable) {
                a.z = a.z - this.overlap;
                a.velocity.z = FlxMath.roundDecimal(this.b_overlap_velocity - this.a_overlap_velocity * a.bounce.z, this.decimal);
            } else if (!b.immovable) {
                b.z += this.overlap;
                b.velocity.z = FlxMath.roundDecimal(this.a_overlap_velocity - this.b_overlap_velocity * b.bounce.z, this.decimal);
            } 

            return true;
        }

        return false; 
    }