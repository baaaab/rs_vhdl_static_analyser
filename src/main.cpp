#include <getopt.h>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>

#include "dot/CDotGraphCreator.h"
#include "elaborator/CElaborator.h"
#include "parser/CParser.h"

void usage(const char* argv0)
{
	fprintf(stderr, "Usage: %s options\n", argv0);
	fprintf(stderr, "Options: \n");
	fprintf(stderr, "\t--vhdl          -v         VHDL file (GHDL synth output)\n");
	fprintf(stderr, "\t--ignore        -i         Signal name to ignore (can be set many times)\n");
	fprintf(stderr, "\t--all-signals   -a         Include auto generated signals in the DOT graph\n");
	exit(1);
}

int main(int argc, char** argv)
{
	static struct option long_options[] =
	{
		{ "vhdl",   required_argument, NULL, 'v' },
		{ "i",      required_argument, NULL, 'i' },
		{ NULL, 0, NULL, 0 }
	};

	int ch;

	const char* inputVhdlFileName = NULL;
	std::vector<std::string> signalNamesToIgnore({ "reset", "sreset" });
	bool userDefinedSignalsOnly = true;

	while ((ch = getopt_long(argc, argv, "v:i:a", long_options, NULL)) != -1)
	{
		switch (ch)
		{
			case 'v':
				inputVhdlFileName = optarg;
				break;
			case 'i':
				signalNamesToIgnore.push_back(optarg);
				break;
			case 'a':
				userDefinedSignalsOnly = false;
				break;
			default:
				usage(argv[0]);
		}
	}

	vhdl::CParser parser;

	parser.parse(inputVhdlFileName);

	vhdl::CElaborator elaborator(&parser);
	//elaborator.printUnassignedSignals();

	elaborator.elaborateSignalsFromPath("");
	//elaborator.printNetlist();

	vhdl::CDotGraphCreator graphCreator("bob.dot", signalNamesToIgnore);
	graphCreator.setUserDefinedSignalsOnly(userDefinedSignalsOnly);
	graphCreator.createDotGraph(elaborator.getNetlist());

	return 0;
}
