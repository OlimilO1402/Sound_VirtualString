/******************************************************************************
File: 		 ds.h
Tab stops: every 2 columns
Project:	 Developer's Guide to DirectX 4
Written:	 96/03/13 by Keith Weiner
Purpose:	 Contains the definition for the DS class
History:	 96/03/13 KW Started
******************************************************************************/



#ifndef ds_INCLUDE

	#define ds_INCLUDE


	#include <mmsystem.h>
	#include <dsound.h>



	#define ds_NUMCHANNELS 16

	#define ds_CHANSPERSAMPLE  1
	#define ds_BITSPERSAMPLE	16
	#define ds_SAMPLERATE 		22050



	typedef class DIRSOUND
	{
		public:
			DIRSOUND(HWND hwnd);
			~DIRSOUND();

			WORD LoadWave(char *filename);	 //returns channel number
			void UnLoadWave(WORD channel);

			void Start(WORD channel, BOOL looping);
			void Stop(WORD channel);
			/* ---------- Methods ---------- */
			WORD AllocChannel(void);

			void CreateBuffer(WORD channel);
			void DestroyBuffer(WORD channel);

			void FillBuffer(WORD channel);

			/* ---------- Data ---------- */
			HWND					hwnd; 			//application's window handle
			LPDIRECTSOUND lpdirsnd;

			/* These fields keep track of each sound */
			BYTE								*sound[ds_NUMCHANNELS];
			DWORD 							 len[ds_NUMCHANNELS];
			LPDIRECTSOUNDBUFFER  lpdsb[ds_NUMCHANNELS];

	} DIRSOUND;



#endif
