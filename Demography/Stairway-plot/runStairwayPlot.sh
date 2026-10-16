# https://github.com/xiaoming-liu/stairway-plot-v2

java -cp stairway_plot_es Stairbuilder Lin1_unfolded.blueprint
java -cp stairway_plot_es Stairbuilder Lin3Mant_unfolded.blueprint
java -cp stairway_plot_es Stairbuilder Lin4_unfolded.blueprint
java -cp stairway_plot_es Stairbuilder Lin5_unfolded.blueprint
java -cp stairway_plot_es Stairbuilder Lin6_unfolded.blueprint
java -cp stairway_plot_es Stairbuilder Lin7_unfolded.blueprint

bash Lin7_unfolded.blueprint.sh 

bash Lin7_unfolded.blueprint.plot.sh
