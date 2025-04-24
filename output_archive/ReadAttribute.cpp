/*
 * Distributed under the OSI-approved Apache License, Version 2.0.  See
 * accompanying file Copyright.txt for details.
 *
 */

#include <ios>       //std::ios_base::failure
#include <iostream>  //std::cout
#include <stdexcept> //std::invalid_argument std::exception
#include <string>
#include <vector>

#include <adios2.h>

int main(int argc, char *argv[])
{
    std::string fname;
    if (argc > 1)
    {
        fname = std::string(argv[1]);
    }
    adios2::ADIOS adios;

    /*** IO class object: settings and factory of Settings: Variables,
     * Parameters, Transports, and Execution: Engines */
    adios2::IO bpIO = adios.DeclareIO("BPFile_N2N");

    adios2::Engine bpReader = bpIO.Open(fname, adios2::Mode::ReadRandomAccess);

    std::vector<float> myFloats;
    adios2::Variable<float> bpFloats = bpIO.InquireVariable<float>("bpFloats");

    bpReader.Get<float>(bpFloats, myFloats, adios2::Mode::Sync);

    const auto attributesInfo = bpIO.AvailableAttributes();

    for (const auto &attributeInfoPair : attributesInfo)
    {
        std::cout << "Attribute: " << attributeInfoPair.first;
        for (const auto &attributePair : attributeInfoPair.second)
        {
            std::cout << "\tKey: " << attributePair.first << "\tValue: " << attributePair.second
                      << "\n";
        }
        std::cout << "\n";
    }

    bpReader.Close();
    return 0;
}
