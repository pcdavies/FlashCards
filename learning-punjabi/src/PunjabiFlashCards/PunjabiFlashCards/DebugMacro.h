//
//  DebugMacro.h
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#ifdef DEBUG
#define DebugLog(...) NSLog(@"%s (%d) %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DebugLog(...)
#endif
