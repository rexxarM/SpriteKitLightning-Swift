//
// Renders a circular pulsating wave effect with fluctuating colors, ignoring any current pixel colors
// Uniform: u_speed, how fast the wave should travel. Ranges from -2 to 2 work best, where negative numbers cause waves to come inwards; try starting with 1.
// Uniform: u_brightness, how bright the colors should be. Ranges from 0 to 5 work best; try starting with 0.5 and experiment.
// Uniform: u_strength, how intense the waves should be. Ranges from 0.02 to 5 work best; try starting with 2.
// Uniform: u_density, how large each wave should be. Ranges from 20 to 500 work best; try starting with 100.
// Uniform: u_center, a CGPoint representing the center of the gradient, where 0.5/0.5 is dead center
// Uniform: u_red, how much red to apply to the colors. Specify 0 to 1 to apply that amount of red, or use any negative number (e.g. -1) to have the amount of red fluctuate.
//
// This works by calculating what a color gradient would look like over the space of the node
// then calculating the pixel's distance from the center of the wave. From there we can calculate
// the brightness of the pixel by taking the cosine the wave density and speed to create a nice and
// smooth effect.
//
// MIT License
//
// Copyright (c) 2017 Paul Hudson
// https://www.github.com/twostraws/ShaderKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

void main() {
    // find the current pixel color
    vec4 current_color = SKDefaultShading();
    
    // if it's not transparent
    if (current_color.a > 0.0) {
        
        gl_FragColor = current_color * current_color.a * v_color_mix.a;

    } else {
        // use the current (transparent) color
        gl_FragColor = current_color;
    }
}

