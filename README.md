##Sound Transfer

Sound Transfer transmits data between computers using your speaker and microphone. Method: transmitter sends message as a series of pitches following a simple protocol. Receiver detects the pitches through Fourier transforms, and converts back into ASCII text format.

Requires [Minim](http://code.compartmental.net/tools/minim/), [Ess](http://www.tree-axis.com/Ess/download.html) libraries (simply download and put in your Processing libraries/ folder.)

Here's the protocol.

	Pitch	Symbol	Meaning
	---------------------------------------
	1976 Hz	 '!'	Begin transmission.
	1174 Hz  '0'	Send a binary 0.
	784 Hz	 '1'	Send a binary 1.
	988 Hz	 '*'	Used as a separator between repeated digits.
	1568 Hz	 '.'	End transmission.
