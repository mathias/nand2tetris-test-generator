#!/usr/bin/env ruby
#
require 'csv'
require 'optparse'

class CmpToTestScript
  def initialize(data:, output_file:, input_file:, verbose:)
    @data = data

    # For now, we just standardize on the ALU inputs and outputs.
    # TODO: Make dynamic in the future!
    @input_pins = ["x", "y", "zx", "nx", "zy", "ny", "f", "no"]
    @output_pins = ["out"] # TODO: also zr and ng

    @input_filename = input_file
    @output_filename = output_file
    @verbose = verbose
  end

  def run
    output = ""
    # Preamble for ALU
    preamble = <<~END
      load ALU.hdl,
      output-file #{@input_filename.sub(/\.cmp\Z/, '.out')},
      compare-to #{@input_filename},
      output-list x%B1.16.1 y%B1.16.1 zx%B1.1.1 nx%B1.1.1 zy%B1.1.1
        ny%B1.1.1 f%B1.1.1 no%B1.1.1 out%B1.16.1;

    END

    p preamble
    output << preamble

    @data.each do |row|
      test = ""
      @input_pins.each do |input|
        val = row[input]
        val = "%B#{val}" if row[input].length > 1

        test << "set #{input} #{val},\n"
      end

      test << "eval,\n"
      test << "output;\n\n"

      p test
      output << test
    end
  end

  def p(str)
    puts str if @verbose
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: cmp-to-test-script.rb [options]"

  opts.on('-f' "--file FILE", "Compare file to turn into a test script") do |file|
    options[:file] = file
  end

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-h", "--help", "Prints this help") do |v|
    options[:help] = true
    puts opts
  end
end.parse!

raise "Must provide file to this script!" unless options[:file] && !options[:help]

data = CSV.read(options[:file],
                headers: true,
                header_converters: [->(value) { value.strip rescue value }],
                converters: [->(value) { value.strip rescue value }],
                col_sep: "|")

CmpToTestScript.new(data: data,
                    output_file: options[:output_file],
                    input_file: options[:file],
                    verbose: options[:verbose]
                   ).run
