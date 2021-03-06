
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 85 18 80       	mov    $0x80188570,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 2d 10 80       	mov    $0x80102d30,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb b4 85 18 80       	mov    $0x801885b4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 6e 10 80       	push   $0x80106ec0
80100055:	68 80 85 18 80       	push   $0x80188580
8010005a:	e8 21 40 00 00       	call   80104080 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 7c cc 18 80       	mov    $0x8018cc7c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 cc cc 18 80 7c 	movl   $0x8018cc7c,0x8018cccc
8010006e:	cc 18 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 d0 cc 18 80 7c 	movl   $0x8018cc7c,0x8018ccd0
80100078:	cc 18 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 7c cc 18 80 	movl   $0x8018cc7c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6e 10 80       	push   $0x80106ec7
80100097:	50                   	push   %eax
80100098:	e8 a3 3e 00 00       	call   80103f40 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 d0 cc 18 80       	mov    0x8018ccd0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d d0 cc 18 80    	mov    %ebx,0x8018ccd0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 20 ca 18 80    	cmp    $0x8018ca20,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 80 85 18 80       	push   $0x80188580
801000e8:	e8 13 41 00 00       	call   80104200 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d d0 cc 18 80    	mov    0x8018ccd0,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 7c cc 18 80    	cmp    $0x8018cc7c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 7c cc 18 80    	cmp    $0x8018cc7c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d cc cc 18 80    	mov    0x8018cccc,%ebx
80100126:	81 fb 7c cc 18 80    	cmp    $0x8018cc7c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 7c cc 18 80    	cmp    $0x8018cc7c,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 80 85 18 80       	push   $0x80188580
80100162:	e8 59 41 00 00       	call   801042c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 3e 00 00       	call   80103f80 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 6c 00 00       	call   80106df0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 6e 10 80       	push   $0x80106ece
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 59 3e 00 00       	call   80104020 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 13 6c 00 00       	jmp    80106df0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 6e 10 80       	push   $0x80106edf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 18 3e 00 00       	call   80104020 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 c8 3d 00 00       	call   80103fe0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 80 85 18 80 	movl   $0x80188580,(%esp)
8010021f:	e8 dc 3f 00 00       	call   80104200 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 d0 cc 18 80       	mov    0x8018ccd0,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 7c cc 18 80 	movl   $0x8018cc7c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 d0 cc 18 80       	mov    0x8018ccd0,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d d0 cc 18 80    	mov    %ebx,0x8018ccd0
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 80 85 18 80 	movl   $0x80188580,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 4b 40 00 00       	jmp    801042c0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 6e 10 80       	push   $0x80106ee6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 75 18 80 	movl   $0x80187520,(%esp)
801002b1:	e8 4a 3f 00 00       	call   80104200 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 60 cf 18 80       	mov    0x8018cf60,%eax
801002cb:	3b 05 64 cf 18 80    	cmp    0x8018cf64,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 75 18 80       	push   $0x80187520
801002e0:	68 60 cf 18 80       	push   $0x8018cf60
801002e5:	e8 e6 38 00 00       	call   80103bd0 <sleep>
    while(input.r == input.w){
801002ea:	a1 60 cf 18 80       	mov    0x8018cf60,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 64 cf 18 80    	cmp    0x8018cf64,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 51 33 00 00       	call   80103650 <myproc>
801002ff:	8b 48 28             	mov    0x28(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 75 18 80       	push   $0x80187520
8010030e:	e8 ad 3f 00 00       	call   801042c0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 60 cf 18 80    	mov    %edx,0x8018cf60
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a e0 ce 18 80 	movsbl -0x7fe73120(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 75 18 80       	push   $0x80187520
80100365:	e8 56 3f 00 00       	call   801042c0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 60 cf 18 80       	mov    %eax,0x8018cf60
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 75 18 80 00 	movl   $0x0,0x80187554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 de 21 00 00       	call   80102590 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 6e 10 80       	push   $0x80106eed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 bb 77 10 80 	movl   $0x801077bb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 bf 3c 00 00       	call   801040a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 6f 10 80       	push   $0x80106f01
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 75 18 80 01 	movl   $0x1,0x80187558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 91 55 00 00       	call   801059c0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 a6 54 00 00       	call   801059c0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 54 00 00       	call   801059c0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 54 00 00       	call   801059c0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 4a 3e 00 00       	call   801043b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 95 3d 00 00       	call   80104310 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 6f 10 80       	push   $0x80106f05
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 30 6f 10 80 	movzbl -0x7fef90d0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 75 18 80    	mov    0x80187558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 75 18 80 	movl   $0x80187520,(%esp)
8010065f:	e8 9c 3b 00 00       	call   80104200 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 75 18 80    	mov    0x80187558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 75 18 80       	push   $0x80187520
80100697:	e8 24 3c 00 00       	call   801042c0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 75 18 80       	mov    0x80187554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 75 18 80    	mov    0x80187558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 18 6f 10 80       	mov    $0x80106f18,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 75 18 80    	mov    0x80187558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 75 18 80       	push   $0x80187520
801007bd:	e8 3e 3a 00 00       	call   80104200 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 75 18 80    	mov    0x80187558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 75 18 80    	mov    0x80187558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 75 18 80    	mov    0x80187558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 75 18 80       	push   $0x80187520
80100828:	e8 93 3a 00 00       	call   801042c0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 6f 10 80       	push   $0x80106f1f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 75 18 80       	push   $0x80187520
80100877:	e8 84 39 00 00       	call   80104200 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 68 cf 18 80       	mov    0x8018cf68,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 60 cf 18 80    	sub    0x8018cf60,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 75 18 80    	mov    0x80187558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d 68 cf 18 80    	mov    %ecx,0x8018cf68
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 e0 ce 18 80    	mov    %bl,-0x7fe73120(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 60 cf 18 80       	mov    0x8018cf60,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 68 cf 18 80    	cmp    %eax,0x8018cf68
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 68 cf 18 80       	mov    0x8018cf68,%eax
80100925:	39 05 64 cf 18 80    	cmp    %eax,0x8018cf64
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba e0 ce 18 80 0a 	cmpb   $0xa,-0x7fe73120(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 75 18 80    	mov    0x80187558,%edx
        input.e--;
8010094c:	a3 68 cf 18 80       	mov    %eax,0x8018cf68
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 68 cf 18 80       	mov    0x8018cf68,%eax
8010096f:	3b 05 64 cf 18 80    	cmp    0x8018cf64,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 68 cf 18 80       	mov    0x8018cf68,%eax
80100985:	3b 05 64 cf 18 80    	cmp    0x8018cf64,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 68 cf 18 80       	mov    %eax,0x8018cf68
  if(panicked){
80100999:	a1 58 75 18 80       	mov    0x80187558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 75 18 80       	push   $0x80187520
801009cf:	e8 ec 38 00 00       	call   801042c0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 e0 ce 18 80 0a 	movb   $0xa,-0x7fe73120(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 6c 34 00 00       	jmp    80103e70 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 68 cf 18 80       	mov    0x8018cf68,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 64 cf 18 80       	mov    %eax,0x8018cf64
          wakeup(&input.r);
80100a1b:	68 60 cf 18 80       	push   $0x8018cf60
80100a20:	e8 5b 33 00 00       	call   80103d80 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 28 6f 10 80       	push   $0x80106f28
80100a3f:	68 20 75 18 80       	push   $0x80187520
80100a44:	e8 37 36 00 00       	call   80104080 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 2c d9 18 80 40 	movl   $0x80100640,0x8018d92c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 28 d9 18 80 90 	movl   $0x80100290,0x8018d928
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 75 18 80 01 	movl   $0x1,0x80187554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ae 16 00 00       	call   80102120 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 bb 2b 00 00       	call   80103650 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 80 1f 00 00       	call   80102a20 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 ff 02 00 00    	je     80100db5 <exec+0x335>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 a8 1f 00 00       	call   80102a90 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 1f 60 00 00       	call   80106b30 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a5 02 00 00    	je     80100dd4 <exec+0x354>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 d8 5d 00 00       	call   80106950 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 d2 5c 00 00       	call   80106880 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 c0 5e 00 00       	call   80106ab0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 6a 1e 00 00       	call   80102a90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 19 5d 00 00       	call   80106950 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 78 5f 00 00       	call   80106bd0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 68 38 00 00       	call   80104510 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 55 38 00 00       	call   80104510 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 60 00 00       	call   80106d30 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 5d 00 00       	call   80106ab0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 f8 5f 00 00       	call   80106d30 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 70             	add    $0x70,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 5a 37 00 00       	call   801044d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz;
80100d81:	89 70 04             	mov    %esi,0x4(%eax)
  curproc->pgdir = pgdir;
80100d84:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d87:	89 c1                	mov    %eax,%ecx
80100d89:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8f:	8b 40 1c             	mov    0x1c(%eax),%eax
80100d92:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d95:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100d98:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9b:	89 0c 24             	mov    %ecx,(%esp)
80100d9e:	e8 4d 59 00 00       	call   801066f0 <switchuvm>
  freevm(oldpgdir);
80100da3:	89 3c 24             	mov    %edi,(%esp)
80100da6:	e8 05 5d 00 00       	call   80106ab0 <freevm>
  return 0;
80100dab:	83 c4 10             	add    $0x10,%esp
80100dae:	31 c0                	xor    %eax,%eax
80100db0:	e9 3b fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db5:	e8 d6 1c 00 00       	call   80102a90 <end_op>
    cprintf("exec: fail\n");
80100dba:	83 ec 0c             	sub    $0xc,%esp
80100dbd:	68 41 6f 10 80       	push   $0x80106f41
80100dc2:	e8 e9 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dcf:	e9 1c fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd4:	31 ff                	xor    %edi,%edi
80100dd6:	be 00 20 00 00       	mov    $0x2000,%esi
80100ddb:	e9 38 fe ff ff       	jmp    80100c18 <exec+0x198>

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 4d 6f 10 80       	push   $0x80106f4d
80100def:	68 80 cf 18 80       	push   $0x8018cf80
80100df4:	e8 87 32 00 00       	call   80104080 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb b4 cf 18 80       	mov    $0x8018cfb4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 80 cf 18 80       	push   $0x8018cf80
80100e15:	e8 e6 33 00 00       	call   80104200 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 14 d9 18 80    	cmp    $0x8018d914,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 80 cf 18 80       	push   $0x8018cf80
80100e41:	e8 7a 34 00 00       	call   801042c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 80 cf 18 80       	push   $0x8018cf80
80100e5a:	e8 61 34 00 00       	call   801042c0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 80 cf 18 80       	push   $0x8018cf80
80100e83:	e8 78 33 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 80 cf 18 80       	push   $0x8018cf80
80100ea0:	e8 1b 34 00 00       	call   801042c0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 54 6f 10 80       	push   $0x80106f54
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 80 cf 18 80       	push   $0x8018cf80
80100ed5:	e8 26 33 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 80 cf 18 80       	push   $0x8018cf80
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 ab 33 00 00       	call   801042c0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 80 cf 18 80 	movl   $0x8018cf80,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 7d 33 00 00       	jmp    801042c0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 d3 1a 00 00       	call   80102a20 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 29 1b 00 00       	jmp    80102a90 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 72 22 00 00       	call   801031f0 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 5c 6f 10 80       	push   $0x80106f5c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 26 23 00 00       	jmp    80103390 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 66 6f 10 80       	push   $0x80106f66
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 9a 19 00 00       	call   80102a90 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 01 19 00 00       	call   80102a20 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 3a 19 00 00       	call   80102a90 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 6f 6f 10 80       	push   $0x80106f6f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 fa 20 00 00       	jmp    80103290 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 75 6f 10 80       	push   $0x80106f75
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 98 d9 18 80    	add    0x8018d998,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 fe 19 00 00       	call   80102c00 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 7f 6f 10 80       	push   $0x80106f7f
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d 80 d9 18 80    	mov    0x8018d980,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 98 d9 18 80    	add    0x8018d998,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 80 d9 18 80       	mov    0x8018d980,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 80 d9 18 80    	cmp    %eax,0x8018d980
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 92 6f 10 80       	push   $0x80106f92
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 0e 19 00 00       	call   80102c00 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 f6 2f 00 00       	call   80104310 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 de 18 00 00       	call   80102c00 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb d4 d9 18 80       	mov    $0x8018d9d4,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 a0 d9 18 80       	push   $0x8018d9a0
8010135a:	e8 a1 2e 00 00       	call   80104200 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb f4 f5 18 80    	cmp    $0x8018f5f4,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb f4 f5 18 80    	cmp    $0x8018f5f4,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 a0 d9 18 80       	push   $0x8018d9a0
801013c7:	e8 f4 2e 00 00       	call   801042c0 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 a0 d9 18 80       	push   $0x8018d9a0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 c6 2e 00 00       	call   801042c0 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb f4 f5 18 80    	cmp    $0x8018f5f4,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 a8 6f 10 80       	push   $0x80106fa8
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 56 17 00 00       	call   80102c00 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 b8 6f 10 80       	push   $0x80106fb8
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 86 2e 00 00       	call   801043b0 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb e0 d9 18 80       	mov    $0x8018d9e0,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 cb 6f 10 80       	push   $0x80106fcb
80101555:	68 a0 d9 18 80       	push   $0x8018d9a0
8010155a:	e8 21 2b 00 00       	call   80104080 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 d2 6f 10 80       	push   $0x80106fd2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 c4 29 00 00       	call   80103f40 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 00 f6 18 80    	cmp    $0x8018f600,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 80 d9 18 80       	push   $0x8018d980
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 98 d9 18 80    	pushl  0x8018d998
8010159d:	ff 35 94 d9 18 80    	pushl  0x8018d994
801015a3:	ff 35 90 d9 18 80    	pushl  0x8018d990
801015a9:	ff 35 8c d9 18 80    	pushl  0x8018d98c
801015af:	ff 35 88 d9 18 80    	pushl  0x8018d988
801015b5:	ff 35 84 d9 18 80    	pushl  0x8018d984
801015bb:	ff 35 80 d9 18 80    	pushl  0x8018d980
801015c1:	68 38 70 10 80       	push   $0x80107038
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d 88 d9 18 80 01 	cmpl   $0x1,0x8018d988
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d 88 d9 18 80    	cmp    0x8018d988,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 94 d9 18 80    	add    0x8018d994,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 ad 2c 00 00       	call   80104310 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 8b 15 00 00       	call   80102c00 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 d8 6f 10 80       	push   $0x80106fd8
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 94 d9 18 80    	add    0x8018d994,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 a6 2c 00 00       	call   801043b0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 ee 14 00 00       	call   80102c00 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 a0 d9 18 80       	push   $0x8018d9a0
80101743:	e8 b8 2a 00 00       	call   80104200 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 a0 d9 18 80 	movl   $0x8018d9a0,(%esp)
80101753:	e8 68 2b 00 00       	call   801042c0 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 f5 27 00 00       	call   80103f80 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 94 d9 18 80    	add    0x8018d994,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 b3 2b 00 00       	call   801043b0 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 f0 6f 10 80       	push   $0x80106ff0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ea 6f 10 80       	push   $0x80106fea
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 c4 27 00 00       	call   80104020 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 68 27 00 00       	jmp    80103fe0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 ff 6f 10 80       	push   $0x80106fff
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 d7 26 00 00       	call   80103f80 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 1d 27 00 00       	call   80103fe0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 a0 d9 18 80 	movl   $0x8018d9a0,(%esp)
801018ca:	e8 31 29 00 00       	call   80104200 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 a0 d9 18 80 	movl   $0x8018d9a0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 d7 29 00 00       	jmp    801042c0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 a0 d9 18 80       	push   $0x8018d9a0
801018f8:	e8 03 29 00 00       	call   80104200 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 a0 d9 18 80 	movl   $0x8018d9a0,(%esp)
80101907:	e8 b4 29 00 00       	call   801042c0 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 a4 28 00 00       	call   801043b0 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 20 d9 18 80 	mov    -0x7fe726e0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 a8 27 00 00       	call   801043b0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 f0 0f 00 00       	call   80102c00 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 24 d9 18 80 	mov    -0x7fe726dc(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 79 27 00 00       	call   80104420 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 16 27 00 00       	call   80104420 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 19 70 10 80       	push   $0x80107019
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 07 70 10 80       	push   $0x80107007
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 c1 18 00 00       	call   80103650 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 a0 d9 18 80       	push   $0x8018d9a0
80101d9c:	e8 5f 24 00 00       	call   80104200 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 a0 d9 18 80 	movl   $0x8018d9a0,(%esp)
80101dac:	e8 0f 25 00 00       	call   801042c0 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 94 25 00 00       	call   801043b0 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 08 25 00 00       	call   801043b0 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 96 24 00 00       	call   80104470 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 28 70 10 80       	push   $0x80107028
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 a2 75 10 80       	push   $0x801075a2
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102075:	c7 05 f4 f5 18 80 00 	movl   $0xfec00000,0x8018f5f4
8010207c:	00 c0 fe 
{
8010207f:	89 e5                	mov    %esp,%ebp
80102081:	56                   	push   %esi
80102082:	53                   	push   %ebx
  ioapic->reg = reg;
80102083:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010208a:	00 00 00 
  return ioapic->data;
8010208d:	8b 15 f4 f5 18 80    	mov    0x8018f5f4,%edx
80102093:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102096:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010209c:	8b 0d f4 f5 18 80    	mov    0x8018f5f4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801020a2:	0f b6 15 20 f7 18 80 	movzbl 0x8018f720,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801020a9:	c1 ee 10             	shr    $0x10,%esi
801020ac:	89 f0                	mov    %esi,%eax
801020ae:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801020b1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801020b4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801020b7:	39 c2                	cmp    %eax,%edx
801020b9:	74 16                	je     801020d1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801020bb:	83 ec 0c             	sub    $0xc,%esp
801020be:	68 8c 70 10 80       	push   $0x8010708c
801020c3:	e8 e8 e5 ff ff       	call   801006b0 <cprintf>
801020c8:	8b 0d f4 f5 18 80    	mov    0x8018f5f4,%ecx
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	83 c6 21             	add    $0x21,%esi
{
801020d4:	ba 10 00 00 00       	mov    $0x10,%edx
801020d9:	b8 20 00 00 00       	mov    $0x20,%eax
801020de:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801020e0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801020e2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801020e4:	8b 0d f4 f5 18 80    	mov    0x8018f5f4,%ecx
801020ea:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801020ed:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801020f3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801020f6:	8d 5a 01             	lea    0x1(%edx),%ebx
801020f9:	83 c2 02             	add    $0x2,%edx
801020fc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801020fe:	8b 0d f4 f5 18 80    	mov    0x8018f5f4,%ecx
80102104:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010210b:	39 f0                	cmp    %esi,%eax
8010210d:	75 d1                	jne    801020e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010210f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102112:	5b                   	pop    %ebx
80102113:	5e                   	pop    %esi
80102114:	5d                   	pop    %ebp
80102115:	c3                   	ret    
80102116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211d:	8d 76 00             	lea    0x0(%esi),%esi

80102120 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102120:	f3 0f 1e fb          	endbr32 
80102124:	55                   	push   %ebp
  ioapic->reg = reg;
80102125:	8b 0d f4 f5 18 80    	mov    0x8018f5f4,%ecx
{
8010212b:	89 e5                	mov    %esp,%ebp
8010212d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102130:	8d 50 20             	lea    0x20(%eax),%edx
80102133:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102137:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102139:	8b 0d f4 f5 18 80    	mov    0x8018f5f4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010213f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102142:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102145:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102148:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010214a:	a1 f4 f5 18 80       	mov    0x8018f5f4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010214f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102152:	89 50 10             	mov    %edx,0x10(%eax)
}
80102155:	5d                   	pop    %ebp
80102156:	c3                   	ret    
80102157:	66 90                	xchg   %ax,%ax
80102159:	66 90                	xchg   %ax,%ax
8010215b:	66 90                	xchg   %ax,%ax
8010215d:	66 90                	xchg   %ax,%ax
8010215f:	90                   	nop

80102160 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	53                   	push   %ebx
80102168:	83 ec 04             	sub    $0x4,%esp
8010216b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010216e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102174:	75 7a                	jne    801021f0 <kfree+0x90>
80102176:	81 fb 68 25 19 80    	cmp    $0x80192568,%ebx
8010217c:	72 72                	jb     801021f0 <kfree+0x90>
8010217e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102184:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102189:	77 65                	ja     801021f0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010218b:	83 ec 04             	sub    $0x4,%esp
8010218e:	68 00 10 00 00       	push   $0x1000
80102193:	6a 01                	push   $0x1
80102195:	53                   	push   %ebx
80102196:	e8 75 21 00 00       	call   80104310 <memset>

  if(kmem.use_lock)
8010219b:	8b 15 34 f6 18 80    	mov    0x8018f634,%edx
801021a1:	83 c4 10             	add    $0x10,%esp
801021a4:	85 d2                	test   %edx,%edx
801021a6:	75 20                	jne    801021c8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801021a8:	a1 38 f6 18 80       	mov    0x8018f638,%eax
801021ad:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801021af:	a1 34 f6 18 80       	mov    0x8018f634,%eax
  kmem.freelist = r;
801021b4:	89 1d 38 f6 18 80    	mov    %ebx,0x8018f638
  if(kmem.use_lock)
801021ba:	85 c0                	test   %eax,%eax
801021bc:	75 22                	jne    801021e0 <kfree+0x80>
    release(&kmem.lock);
}
801021be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021c1:	c9                   	leave  
801021c2:	c3                   	ret    
801021c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c7:	90                   	nop
    acquire(&kmem.lock);
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 00 f6 18 80       	push   $0x8018f600
801021d0:	e8 2b 20 00 00       	call   80104200 <acquire>
801021d5:	83 c4 10             	add    $0x10,%esp
801021d8:	eb ce                	jmp    801021a8 <kfree+0x48>
801021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801021e0:	c7 45 08 00 f6 18 80 	movl   $0x8018f600,0x8(%ebp)
}
801021e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021ea:	c9                   	leave  
    release(&kmem.lock);
801021eb:	e9 d0 20 00 00       	jmp    801042c0 <release>
    panic("kfree");
801021f0:	83 ec 0c             	sub    $0xc,%esp
801021f3:	68 be 70 10 80       	push   $0x801070be
801021f8:	e8 93 e1 ff ff       	call   80100390 <panic>
801021fd:	8d 76 00             	lea    0x0(%esi),%esi

80102200 <freerange>:
{
80102200:	f3 0f 1e fb          	endbr32 
80102204:	55                   	push   %ebp
80102205:	89 e5                	mov    %esp,%ebp
80102207:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102208:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010220b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010220e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010220f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102215:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010221b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102221:	39 de                	cmp    %ebx,%esi
80102223:	72 1f                	jb     80102244 <freerange+0x44>
80102225:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102231:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102237:	50                   	push   %eax
80102238:	e8 23 ff ff ff       	call   80102160 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	39 f3                	cmp    %esi,%ebx
80102242:	76 e4                	jbe    80102228 <freerange+0x28>
}
80102244:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102247:	5b                   	pop    %ebx
80102248:	5e                   	pop    %esi
80102249:	5d                   	pop    %ebp
8010224a:	c3                   	ret    
8010224b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <kinit1>:
{
80102250:	f3 0f 1e fb          	endbr32 
80102254:	55                   	push   %ebp
80102255:	89 e5                	mov    %esp,%ebp
80102257:	56                   	push   %esi
80102258:	53                   	push   %ebx
80102259:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010225c:	83 ec 08             	sub    $0x8,%esp
8010225f:	68 c4 70 10 80       	push   $0x801070c4
80102264:	68 00 f6 18 80       	push   $0x8018f600
80102269:	e8 12 1e 00 00       	call   80104080 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010226e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102271:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102274:	c7 05 34 f6 18 80 00 	movl   $0x0,0x8018f634
8010227b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010227e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102284:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010228a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102290:	39 de                	cmp    %ebx,%esi
80102292:	72 20                	jb     801022b4 <kinit1+0x64>
80102294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102298:	83 ec 0c             	sub    $0xc,%esp
8010229b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801022a7:	50                   	push   %eax
801022a8:	e8 b3 fe ff ff       	call   80102160 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022ad:	83 c4 10             	add    $0x10,%esp
801022b0:	39 de                	cmp    %ebx,%esi
801022b2:	73 e4                	jae    80102298 <kinit1+0x48>
}
801022b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022b7:	5b                   	pop    %ebx
801022b8:	5e                   	pop    %esi
801022b9:	5d                   	pop    %ebp
801022ba:	c3                   	ret    
801022bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop

801022c0 <kinit2>:
{
801022c0:	f3 0f 1e fb          	endbr32 
801022c4:	55                   	push   %ebp
801022c5:	89 e5                	mov    %esp,%ebp
801022c7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801022c8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801022cb:	8b 75 0c             	mov    0xc(%ebp),%esi
801022ce:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801022cf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801022d5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022e1:	39 de                	cmp    %ebx,%esi
801022e3:	72 1f                	jb     80102304 <kinit2+0x44>
801022e5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801022e8:	83 ec 0c             	sub    $0xc,%esp
801022eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801022f7:	50                   	push   %eax
801022f8:	e8 63 fe ff ff       	call   80102160 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022fd:	83 c4 10             	add    $0x10,%esp
80102300:	39 de                	cmp    %ebx,%esi
80102302:	73 e4                	jae    801022e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102304:	c7 05 34 f6 18 80 01 	movl   $0x1,0x8018f634
8010230b:	00 00 00 
}
8010230e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102311:	5b                   	pop    %ebx
80102312:	5e                   	pop    %esi
80102313:	5d                   	pop    %ebp
80102314:	c3                   	ret    
80102315:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102320 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102320:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102324:	a1 34 f6 18 80       	mov    0x8018f634,%eax
80102329:	85 c0                	test   %eax,%eax
8010232b:	75 1b                	jne    80102348 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010232d:	a1 38 f6 18 80       	mov    0x8018f638,%eax
  if(r)
80102332:	85 c0                	test   %eax,%eax
80102334:	74 0a                	je     80102340 <kalloc+0x20>
    kmem.freelist = r->next;
80102336:	8b 10                	mov    (%eax),%edx
80102338:	89 15 38 f6 18 80    	mov    %edx,0x8018f638
  if(kmem.use_lock)
8010233e:	c3                   	ret    
8010233f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102340:	c3                   	ret    
80102341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102348:	55                   	push   %ebp
80102349:	89 e5                	mov    %esp,%ebp
8010234b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010234e:	68 00 f6 18 80       	push   $0x8018f600
80102353:	e8 a8 1e 00 00       	call   80104200 <acquire>
  r = kmem.freelist;
80102358:	a1 38 f6 18 80       	mov    0x8018f638,%eax
  if(r)
8010235d:	8b 15 34 f6 18 80    	mov    0x8018f634,%edx
80102363:	83 c4 10             	add    $0x10,%esp
80102366:	85 c0                	test   %eax,%eax
80102368:	74 08                	je     80102372 <kalloc+0x52>
    kmem.freelist = r->next;
8010236a:	8b 08                	mov    (%eax),%ecx
8010236c:	89 0d 38 f6 18 80    	mov    %ecx,0x8018f638
  if(kmem.use_lock)
80102372:	85 d2                	test   %edx,%edx
80102374:	74 16                	je     8010238c <kalloc+0x6c>
    release(&kmem.lock);
80102376:	83 ec 0c             	sub    $0xc,%esp
80102379:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010237c:	68 00 f6 18 80       	push   $0x8018f600
80102381:	e8 3a 1f 00 00       	call   801042c0 <release>
  return (char*)r;
80102386:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102389:	83 c4 10             	add    $0x10,%esp
}
8010238c:	c9                   	leave  
8010238d:	c3                   	ret    
8010238e:	66 90                	xchg   %ax,%ax

80102390 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102390:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102394:	ba 64 00 00 00       	mov    $0x64,%edx
80102399:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010239a:	a8 01                	test   $0x1,%al
8010239c:	0f 84 be 00 00 00    	je     80102460 <kbdgetc+0xd0>
{
801023a2:	55                   	push   %ebp
801023a3:	ba 60 00 00 00       	mov    $0x60,%edx
801023a8:	89 e5                	mov    %esp,%ebp
801023aa:	53                   	push   %ebx
801023ab:	ec                   	in     (%dx),%al
  return data;
801023ac:	8b 1d 5c 75 18 80    	mov    0x8018755c,%ebx
    return -1;
  data = inb(KBDATAP);
801023b2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801023b5:	3c e0                	cmp    $0xe0,%al
801023b7:	74 57                	je     80102410 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801023b9:	89 d9                	mov    %ebx,%ecx
801023bb:	83 e1 40             	and    $0x40,%ecx
801023be:	84 c0                	test   %al,%al
801023c0:	78 5e                	js     80102420 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801023c2:	85 c9                	test   %ecx,%ecx
801023c4:	74 09                	je     801023cf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801023c6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801023c9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801023cc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801023cf:	0f b6 8a 00 72 10 80 	movzbl -0x7fef8e00(%edx),%ecx
  shift ^= togglecode[data];
801023d6:	0f b6 82 00 71 10 80 	movzbl -0x7fef8f00(%edx),%eax
  shift |= shiftcode[data];
801023dd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801023df:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801023e1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801023e3:	89 0d 5c 75 18 80    	mov    %ecx,0x8018755c
  c = charcode[shift & (CTL | SHIFT)][data];
801023e9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801023ec:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801023ef:	8b 04 85 e0 70 10 80 	mov    -0x7fef8f20(,%eax,4),%eax
801023f6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801023fa:	74 0b                	je     80102407 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801023fc:	8d 50 9f             	lea    -0x61(%eax),%edx
801023ff:	83 fa 19             	cmp    $0x19,%edx
80102402:	77 44                	ja     80102448 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102404:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102407:	5b                   	pop    %ebx
80102408:	5d                   	pop    %ebp
80102409:	c3                   	ret    
8010240a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102410:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102413:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102415:	89 1d 5c 75 18 80    	mov    %ebx,0x8018755c
}
8010241b:	5b                   	pop    %ebx
8010241c:	5d                   	pop    %ebp
8010241d:	c3                   	ret    
8010241e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102420:	83 e0 7f             	and    $0x7f,%eax
80102423:	85 c9                	test   %ecx,%ecx
80102425:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102428:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010242a:	0f b6 8a 00 72 10 80 	movzbl -0x7fef8e00(%edx),%ecx
80102431:	83 c9 40             	or     $0x40,%ecx
80102434:	0f b6 c9             	movzbl %cl,%ecx
80102437:	f7 d1                	not    %ecx
80102439:	21 d9                	and    %ebx,%ecx
}
8010243b:	5b                   	pop    %ebx
8010243c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010243d:	89 0d 5c 75 18 80    	mov    %ecx,0x8018755c
}
80102443:	c3                   	ret    
80102444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102448:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010244b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010244e:	5b                   	pop    %ebx
8010244f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102450:	83 f9 1a             	cmp    $0x1a,%ecx
80102453:	0f 42 c2             	cmovb  %edx,%eax
}
80102456:	c3                   	ret    
80102457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245e:	66 90                	xchg   %ax,%ax
    return -1;
80102460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102465:	c3                   	ret    
80102466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246d:	8d 76 00             	lea    0x0(%esi),%esi

80102470 <kbdintr>:

void
kbdintr(void)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010247a:	68 90 23 10 80       	push   $0x80102390
8010247f:	e8 dc e3 ff ff       	call   80100860 <consoleintr>
}
80102484:	83 c4 10             	add    $0x10,%esp
80102487:	c9                   	leave  
80102488:	c3                   	ret    
80102489:	66 90                	xchg   %ax,%ax
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102490:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102494:	a1 3c f6 18 80       	mov    0x8018f63c,%eax
80102499:	85 c0                	test   %eax,%eax
8010249b:	0f 84 c7 00 00 00    	je     80102568 <lapicinit+0xd8>
  lapic[index] = value;
801024a1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801024a8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024ae:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801024b5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024bb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801024c2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801024c5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024c8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801024cf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801024d2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024d5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801024dc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801024df:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024e2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801024e9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801024ec:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801024ef:	8b 50 30             	mov    0x30(%eax),%edx
801024f2:	c1 ea 10             	shr    $0x10,%edx
801024f5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801024fb:	75 73                	jne    80102570 <lapicinit+0xe0>
  lapic[index] = value;
801024fd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102504:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102507:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010250a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102511:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102514:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102517:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010251e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102521:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102524:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010252b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010252e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102531:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102538:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010253b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010253e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102545:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102548:	8b 50 20             	mov    0x20(%eax),%edx
8010254b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010254f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102550:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102556:	80 e6 10             	and    $0x10,%dh
80102559:	75 f5                	jne    80102550 <lapicinit+0xc0>
  lapic[index] = value;
8010255b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102562:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102565:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102568:	c3                   	ret    
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102570:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102577:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010257a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010257d:	e9 7b ff ff ff       	jmp    801024fd <lapicinit+0x6d>
80102582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102590 <lapicid>:

int
lapicid(void)
{
80102590:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102594:	a1 3c f6 18 80       	mov    0x8018f63c,%eax
80102599:	85 c0                	test   %eax,%eax
8010259b:	74 0b                	je     801025a8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010259d:	8b 40 20             	mov    0x20(%eax),%eax
801025a0:	c1 e8 18             	shr    $0x18,%eax
801025a3:	c3                   	ret    
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801025a8:	31 c0                	xor    %eax,%eax
}
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801025b0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801025b4:	a1 3c f6 18 80       	mov    0x8018f63c,%eax
801025b9:	85 c0                	test   %eax,%eax
801025bb:	74 0d                	je     801025ca <lapiceoi+0x1a>
  lapic[index] = value;
801025bd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801025c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025c7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801025d0:	f3 0f 1e fb          	endbr32 
}
801025d4:	c3                   	ret    
801025d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	b8 0f 00 00 00       	mov    $0xf,%eax
801025ea:	ba 70 00 00 00       	mov    $0x70,%edx
801025ef:	89 e5                	mov    %esp,%ebp
801025f1:	53                   	push   %ebx
801025f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801025f8:	ee                   	out    %al,(%dx)
801025f9:	b8 0a 00 00 00       	mov    $0xa,%eax
801025fe:	ba 71 00 00 00       	mov    $0x71,%edx
80102603:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102604:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102606:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102609:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010260f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102611:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102614:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102616:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102619:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010261c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102622:	a1 3c f6 18 80       	mov    0x8018f63c,%eax
80102627:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010262d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102630:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102637:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010263a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010263d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102644:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102647:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010264a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102650:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102653:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102659:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010265c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102662:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102665:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010266b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010266c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010266f:	5d                   	pop    %ebp
80102670:	c3                   	ret    
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267f:	90                   	nop

80102680 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102680:	f3 0f 1e fb          	endbr32 
80102684:	55                   	push   %ebp
80102685:	b8 0b 00 00 00       	mov    $0xb,%eax
8010268a:	ba 70 00 00 00       	mov    $0x70,%edx
8010268f:	89 e5                	mov    %esp,%ebp
80102691:	57                   	push   %edi
80102692:	56                   	push   %esi
80102693:	53                   	push   %ebx
80102694:	83 ec 4c             	sub    $0x4c,%esp
80102697:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102698:	ba 71 00 00 00       	mov    $0x71,%edx
8010269d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010269e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026a1:	bb 70 00 00 00       	mov    $0x70,%ebx
801026a6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b0:	31 c0                	xor    %eax,%eax
801026b2:	89 da                	mov    %ebx,%edx
801026b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b5:	b9 71 00 00 00       	mov    $0x71,%ecx
801026ba:	89 ca                	mov    %ecx,%edx
801026bc:	ec                   	in     (%dx),%al
801026bd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026c0:	89 da                	mov    %ebx,%edx
801026c2:	b8 02 00 00 00       	mov    $0x2,%eax
801026c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c8:	89 ca                	mov    %ecx,%edx
801026ca:	ec                   	in     (%dx),%al
801026cb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ce:	89 da                	mov    %ebx,%edx
801026d0:	b8 04 00 00 00       	mov    $0x4,%eax
801026d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d6:	89 ca                	mov    %ecx,%edx
801026d8:	ec                   	in     (%dx),%al
801026d9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026dc:	89 da                	mov    %ebx,%edx
801026de:	b8 07 00 00 00       	mov    $0x7,%eax
801026e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e4:	89 ca                	mov    %ecx,%edx
801026e6:	ec                   	in     (%dx),%al
801026e7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ea:	89 da                	mov    %ebx,%edx
801026ec:	b8 08 00 00 00       	mov    $0x8,%eax
801026f1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f2:	89 ca                	mov    %ecx,%edx
801026f4:	ec                   	in     (%dx),%al
801026f5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026f7:	89 da                	mov    %ebx,%edx
801026f9:	b8 09 00 00 00       	mov    $0x9,%eax
801026fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026ff:	89 ca                	mov    %ecx,%edx
80102701:	ec                   	in     (%dx),%al
80102702:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102704:	89 da                	mov    %ebx,%edx
80102706:	b8 0a 00 00 00       	mov    $0xa,%eax
8010270b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010270c:	89 ca                	mov    %ecx,%edx
8010270e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010270f:	84 c0                	test   %al,%al
80102711:	78 9d                	js     801026b0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102713:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102717:	89 fa                	mov    %edi,%edx
80102719:	0f b6 fa             	movzbl %dl,%edi
8010271c:	89 f2                	mov    %esi,%edx
8010271e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102721:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102725:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102728:	89 da                	mov    %ebx,%edx
8010272a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010272d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102730:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102734:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102737:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010273a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010273e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102741:	31 c0                	xor    %eax,%eax
80102743:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102744:	89 ca                	mov    %ecx,%edx
80102746:	ec                   	in     (%dx),%al
80102747:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010274a:	89 da                	mov    %ebx,%edx
8010274c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010274f:	b8 02 00 00 00       	mov    $0x2,%eax
80102754:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102755:	89 ca                	mov    %ecx,%edx
80102757:	ec                   	in     (%dx),%al
80102758:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010275b:	89 da                	mov    %ebx,%edx
8010275d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102760:	b8 04 00 00 00       	mov    $0x4,%eax
80102765:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102766:	89 ca                	mov    %ecx,%edx
80102768:	ec                   	in     (%dx),%al
80102769:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010276c:	89 da                	mov    %ebx,%edx
8010276e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102771:	b8 07 00 00 00       	mov    $0x7,%eax
80102776:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102777:	89 ca                	mov    %ecx,%edx
80102779:	ec                   	in     (%dx),%al
8010277a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010277d:	89 da                	mov    %ebx,%edx
8010277f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102782:	b8 08 00 00 00       	mov    $0x8,%eax
80102787:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102788:	89 ca                	mov    %ecx,%edx
8010278a:	ec                   	in     (%dx),%al
8010278b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010278e:	89 da                	mov    %ebx,%edx
80102790:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102793:	b8 09 00 00 00       	mov    $0x9,%eax
80102798:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102799:	89 ca                	mov    %ecx,%edx
8010279b:	ec                   	in     (%dx),%al
8010279c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010279f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801027a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801027a5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801027a8:	6a 18                	push   $0x18
801027aa:	50                   	push   %eax
801027ab:	8d 45 b8             	lea    -0x48(%ebp),%eax
801027ae:	50                   	push   %eax
801027af:	e8 ac 1b 00 00       	call   80104360 <memcmp>
801027b4:	83 c4 10             	add    $0x10,%esp
801027b7:	85 c0                	test   %eax,%eax
801027b9:	0f 85 f1 fe ff ff    	jne    801026b0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801027bf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801027c3:	75 78                	jne    8010283d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801027c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801027c8:	89 c2                	mov    %eax,%edx
801027ca:	83 e0 0f             	and    $0xf,%eax
801027cd:	c1 ea 04             	shr    $0x4,%edx
801027d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801027d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801027d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801027d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801027dc:	89 c2                	mov    %eax,%edx
801027de:	83 e0 0f             	and    $0xf,%eax
801027e1:	c1 ea 04             	shr    $0x4,%edx
801027e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801027e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801027ea:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801027ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
801027f0:	89 c2                	mov    %eax,%edx
801027f2:	83 e0 0f             	and    $0xf,%eax
801027f5:	c1 ea 04             	shr    $0x4,%edx
801027f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801027fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801027fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102801:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102804:	89 c2                	mov    %eax,%edx
80102806:	83 e0 0f             	and    $0xf,%eax
80102809:	c1 ea 04             	shr    $0x4,%edx
8010280c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010280f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102812:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102815:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102818:	89 c2                	mov    %eax,%edx
8010281a:	83 e0 0f             	and    $0xf,%eax
8010281d:	c1 ea 04             	shr    $0x4,%edx
80102820:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102823:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102826:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102829:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010282c:	89 c2                	mov    %eax,%edx
8010282e:	83 e0 0f             	and    $0xf,%eax
80102831:	c1 ea 04             	shr    $0x4,%edx
80102834:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102837:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010283a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010283d:	8b 75 08             	mov    0x8(%ebp),%esi
80102840:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102843:	89 06                	mov    %eax,(%esi)
80102845:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102848:	89 46 04             	mov    %eax,0x4(%esi)
8010284b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010284e:	89 46 08             	mov    %eax,0x8(%esi)
80102851:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102854:	89 46 0c             	mov    %eax,0xc(%esi)
80102857:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010285a:	89 46 10             	mov    %eax,0x10(%esi)
8010285d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102860:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102863:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010286a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010286d:	5b                   	pop    %ebx
8010286e:	5e                   	pop    %esi
8010286f:	5f                   	pop    %edi
80102870:	5d                   	pop    %ebp
80102871:	c3                   	ret    
80102872:	66 90                	xchg   %ax,%ax
80102874:	66 90                	xchg   %ax,%ax
80102876:	66 90                	xchg   %ax,%ax
80102878:	66 90                	xchg   %ax,%ax
8010287a:	66 90                	xchg   %ax,%ax
8010287c:	66 90                	xchg   %ax,%ax
8010287e:	66 90                	xchg   %ax,%ax

80102880 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102880:	8b 0d 88 f6 18 80    	mov    0x8018f688,%ecx
80102886:	85 c9                	test   %ecx,%ecx
80102888:	0f 8e 8a 00 00 00    	jle    80102918 <install_trans+0x98>
{
8010288e:	55                   	push   %ebp
8010288f:	89 e5                	mov    %esp,%ebp
80102891:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102892:	31 ff                	xor    %edi,%edi
{
80102894:	56                   	push   %esi
80102895:	53                   	push   %ebx
80102896:	83 ec 0c             	sub    $0xc,%esp
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801028a0:	a1 74 f6 18 80       	mov    0x8018f674,%eax
801028a5:	83 ec 08             	sub    $0x8,%esp
801028a8:	01 f8                	add    %edi,%eax
801028aa:	83 c0 01             	add    $0x1,%eax
801028ad:	50                   	push   %eax
801028ae:	ff 35 84 f6 18 80    	pushl  0x8018f684
801028b4:	e8 17 d8 ff ff       	call   801000d0 <bread>
801028b9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801028bb:	58                   	pop    %eax
801028bc:	5a                   	pop    %edx
801028bd:	ff 34 bd 8c f6 18 80 	pushl  -0x7fe70974(,%edi,4)
801028c4:	ff 35 84 f6 18 80    	pushl  0x8018f684
  for (tail = 0; tail < log.lh.n; tail++) {
801028ca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801028cd:	e8 fe d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801028d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801028d5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801028d7:	8d 46 5c             	lea    0x5c(%esi),%eax
801028da:	68 00 02 00 00       	push   $0x200
801028df:	50                   	push   %eax
801028e0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801028e3:	50                   	push   %eax
801028e4:	e8 c7 1a 00 00       	call   801043b0 <memmove>
    bwrite(dbuf);  // write dst to disk
801028e9:	89 1c 24             	mov    %ebx,(%esp)
801028ec:	e8 bf d8 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801028f1:	89 34 24             	mov    %esi,(%esp)
801028f4:	e8 f7 d8 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801028f9:	89 1c 24             	mov    %ebx,(%esp)
801028fc:	e8 ef d8 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102901:	83 c4 10             	add    $0x10,%esp
80102904:	39 3d 88 f6 18 80    	cmp    %edi,0x8018f688
8010290a:	7f 94                	jg     801028a0 <install_trans+0x20>
  }
}
8010290c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010290f:	5b                   	pop    %ebx
80102910:	5e                   	pop    %esi
80102911:	5f                   	pop    %edi
80102912:	5d                   	pop    %ebp
80102913:	c3                   	ret    
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102918:	c3                   	ret    
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
80102923:	53                   	push   %ebx
80102924:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102927:	ff 35 74 f6 18 80    	pushl  0x8018f674
8010292d:	ff 35 84 f6 18 80    	pushl  0x8018f684
80102933:	e8 98 d7 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102938:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010293b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010293d:	a1 88 f6 18 80       	mov    0x8018f688,%eax
80102942:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102945:	85 c0                	test   %eax,%eax
80102947:	7e 19                	jle    80102962 <write_head+0x42>
80102949:	31 d2                	xor    %edx,%edx
8010294b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102950:	8b 0c 95 8c f6 18 80 	mov    -0x7fe70974(,%edx,4),%ecx
80102957:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010295b:	83 c2 01             	add    $0x1,%edx
8010295e:	39 d0                	cmp    %edx,%eax
80102960:	75 ee                	jne    80102950 <write_head+0x30>
  }
  bwrite(buf);
80102962:	83 ec 0c             	sub    $0xc,%esp
80102965:	53                   	push   %ebx
80102966:	e8 45 d8 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010296b:	89 1c 24             	mov    %ebx,(%esp)
8010296e:	e8 7d d8 ff ff       	call   801001f0 <brelse>
}
80102973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102976:	83 c4 10             	add    $0x10,%esp
80102979:	c9                   	leave  
8010297a:	c3                   	ret    
8010297b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010297f:	90                   	nop

80102980 <initlog>:
{
80102980:	f3 0f 1e fb          	endbr32 
80102984:	55                   	push   %ebp
80102985:	89 e5                	mov    %esp,%ebp
80102987:	53                   	push   %ebx
80102988:	83 ec 2c             	sub    $0x2c,%esp
8010298b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010298e:	68 00 73 10 80       	push   $0x80107300
80102993:	68 40 f6 18 80       	push   $0x8018f640
80102998:	e8 e3 16 00 00       	call   80104080 <initlock>
  readsb(dev, &sb);
8010299d:	58                   	pop    %eax
8010299e:	8d 45 dc             	lea    -0x24(%ebp),%eax
801029a1:	5a                   	pop    %edx
801029a2:	50                   	push   %eax
801029a3:	53                   	push   %ebx
801029a4:	e8 57 eb ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
801029a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801029ac:	59                   	pop    %ecx
  log.dev = dev;
801029ad:	89 1d 84 f6 18 80    	mov    %ebx,0x8018f684
  log.size = sb.nlog;
801029b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801029b6:	a3 74 f6 18 80       	mov    %eax,0x8018f674
  log.size = sb.nlog;
801029bb:	89 15 78 f6 18 80    	mov    %edx,0x8018f678
  struct buf *buf = bread(log.dev, log.start);
801029c1:	5a                   	pop    %edx
801029c2:	50                   	push   %eax
801029c3:	53                   	push   %ebx
801029c4:	e8 07 d7 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801029c9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801029cc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801029cf:	89 0d 88 f6 18 80    	mov    %ecx,0x8018f688
  for (i = 0; i < log.lh.n; i++) {
801029d5:	85 c9                	test   %ecx,%ecx
801029d7:	7e 19                	jle    801029f2 <initlog+0x72>
801029d9:	31 d2                	xor    %edx,%edx
801029db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029df:	90                   	nop
    log.lh.block[i] = lh->block[i];
801029e0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801029e4:	89 1c 95 8c f6 18 80 	mov    %ebx,-0x7fe70974(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801029eb:	83 c2 01             	add    $0x1,%edx
801029ee:	39 d1                	cmp    %edx,%ecx
801029f0:	75 ee                	jne    801029e0 <initlog+0x60>
  brelse(buf);
801029f2:	83 ec 0c             	sub    $0xc,%esp
801029f5:	50                   	push   %eax
801029f6:	e8 f5 d7 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801029fb:	e8 80 fe ff ff       	call   80102880 <install_trans>
  log.lh.n = 0;
80102a00:	c7 05 88 f6 18 80 00 	movl   $0x0,0x8018f688
80102a07:	00 00 00 
  write_head(); // clear the log
80102a0a:	e8 11 ff ff ff       	call   80102920 <write_head>
}
80102a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a12:	83 c4 10             	add    $0x10,%esp
80102a15:	c9                   	leave  
80102a16:	c3                   	ret    
80102a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102a20:	f3 0f 1e fb          	endbr32 
80102a24:	55                   	push   %ebp
80102a25:	89 e5                	mov    %esp,%ebp
80102a27:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102a2a:	68 40 f6 18 80       	push   $0x8018f640
80102a2f:	e8 cc 17 00 00       	call   80104200 <acquire>
80102a34:	83 c4 10             	add    $0x10,%esp
80102a37:	eb 1c                	jmp    80102a55 <begin_op+0x35>
80102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102a40:	83 ec 08             	sub    $0x8,%esp
80102a43:	68 40 f6 18 80       	push   $0x8018f640
80102a48:	68 40 f6 18 80       	push   $0x8018f640
80102a4d:	e8 7e 11 00 00       	call   80103bd0 <sleep>
80102a52:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102a55:	a1 80 f6 18 80       	mov    0x8018f680,%eax
80102a5a:	85 c0                	test   %eax,%eax
80102a5c:	75 e2                	jne    80102a40 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102a5e:	a1 7c f6 18 80       	mov    0x8018f67c,%eax
80102a63:	8b 15 88 f6 18 80    	mov    0x8018f688,%edx
80102a69:	83 c0 01             	add    $0x1,%eax
80102a6c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102a6f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102a72:	83 fa 1e             	cmp    $0x1e,%edx
80102a75:	7f c9                	jg     80102a40 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102a77:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102a7a:	a3 7c f6 18 80       	mov    %eax,0x8018f67c
      release(&log.lock);
80102a7f:	68 40 f6 18 80       	push   $0x8018f640
80102a84:	e8 37 18 00 00       	call   801042c0 <release>
      break;
    }
  }
}
80102a89:	83 c4 10             	add    $0x10,%esp
80102a8c:	c9                   	leave  
80102a8d:	c3                   	ret    
80102a8e:	66 90                	xchg   %ax,%ax

80102a90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102a90:	f3 0f 1e fb          	endbr32 
80102a94:	55                   	push   %ebp
80102a95:	89 e5                	mov    %esp,%ebp
80102a97:	57                   	push   %edi
80102a98:	56                   	push   %esi
80102a99:	53                   	push   %ebx
80102a9a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102a9d:	68 40 f6 18 80       	push   $0x8018f640
80102aa2:	e8 59 17 00 00       	call   80104200 <acquire>
  log.outstanding -= 1;
80102aa7:	a1 7c f6 18 80       	mov    0x8018f67c,%eax
  if(log.committing)
80102aac:	8b 35 80 f6 18 80    	mov    0x8018f680,%esi
80102ab2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ab5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ab8:	89 1d 7c f6 18 80    	mov    %ebx,0x8018f67c
  if(log.committing)
80102abe:	85 f6                	test   %esi,%esi
80102ac0:	0f 85 1e 01 00 00    	jne    80102be4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ac6:	85 db                	test   %ebx,%ebx
80102ac8:	0f 85 f2 00 00 00    	jne    80102bc0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102ace:	c7 05 80 f6 18 80 01 	movl   $0x1,0x8018f680
80102ad5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ad8:	83 ec 0c             	sub    $0xc,%esp
80102adb:	68 40 f6 18 80       	push   $0x8018f640
80102ae0:	e8 db 17 00 00       	call   801042c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ae5:	8b 0d 88 f6 18 80    	mov    0x8018f688,%ecx
80102aeb:	83 c4 10             	add    $0x10,%esp
80102aee:	85 c9                	test   %ecx,%ecx
80102af0:	7f 3e                	jg     80102b30 <end_op+0xa0>
    acquire(&log.lock);
80102af2:	83 ec 0c             	sub    $0xc,%esp
80102af5:	68 40 f6 18 80       	push   $0x8018f640
80102afa:	e8 01 17 00 00       	call   80104200 <acquire>
    wakeup(&log);
80102aff:	c7 04 24 40 f6 18 80 	movl   $0x8018f640,(%esp)
    log.committing = 0;
80102b06:	c7 05 80 f6 18 80 00 	movl   $0x0,0x8018f680
80102b0d:	00 00 00 
    wakeup(&log);
80102b10:	e8 6b 12 00 00       	call   80103d80 <wakeup>
    release(&log.lock);
80102b15:	c7 04 24 40 f6 18 80 	movl   $0x8018f640,(%esp)
80102b1c:	e8 9f 17 00 00       	call   801042c0 <release>
80102b21:	83 c4 10             	add    $0x10,%esp
}
80102b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b27:	5b                   	pop    %ebx
80102b28:	5e                   	pop    %esi
80102b29:	5f                   	pop    %edi
80102b2a:	5d                   	pop    %ebp
80102b2b:	c3                   	ret    
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102b30:	a1 74 f6 18 80       	mov    0x8018f674,%eax
80102b35:	83 ec 08             	sub    $0x8,%esp
80102b38:	01 d8                	add    %ebx,%eax
80102b3a:	83 c0 01             	add    $0x1,%eax
80102b3d:	50                   	push   %eax
80102b3e:	ff 35 84 f6 18 80    	pushl  0x8018f684
80102b44:	e8 87 d5 ff ff       	call   801000d0 <bread>
80102b49:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b4b:	58                   	pop    %eax
80102b4c:	5a                   	pop    %edx
80102b4d:	ff 34 9d 8c f6 18 80 	pushl  -0x7fe70974(,%ebx,4)
80102b54:	ff 35 84 f6 18 80    	pushl  0x8018f684
  for (tail = 0; tail < log.lh.n; tail++) {
80102b5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b5d:	e8 6e d5 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102b62:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b65:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102b67:	8d 40 5c             	lea    0x5c(%eax),%eax
80102b6a:	68 00 02 00 00       	push   $0x200
80102b6f:	50                   	push   %eax
80102b70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b73:	50                   	push   %eax
80102b74:	e8 37 18 00 00       	call   801043b0 <memmove>
    bwrite(to);  // write the log
80102b79:	89 34 24             	mov    %esi,(%esp)
80102b7c:	e8 2f d6 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102b81:	89 3c 24             	mov    %edi,(%esp)
80102b84:	e8 67 d6 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102b89:	89 34 24             	mov    %esi,(%esp)
80102b8c:	e8 5f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b91:	83 c4 10             	add    $0x10,%esp
80102b94:	3b 1d 88 f6 18 80    	cmp    0x8018f688,%ebx
80102b9a:	7c 94                	jl     80102b30 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102b9c:	e8 7f fd ff ff       	call   80102920 <write_head>
    install_trans(); // Now install writes to home locations
80102ba1:	e8 da fc ff ff       	call   80102880 <install_trans>
    log.lh.n = 0;
80102ba6:	c7 05 88 f6 18 80 00 	movl   $0x0,0x8018f688
80102bad:	00 00 00 
    write_head();    // Erase the transaction from the log
80102bb0:	e8 6b fd ff ff       	call   80102920 <write_head>
80102bb5:	e9 38 ff ff ff       	jmp    80102af2 <end_op+0x62>
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102bc0:	83 ec 0c             	sub    $0xc,%esp
80102bc3:	68 40 f6 18 80       	push   $0x8018f640
80102bc8:	e8 b3 11 00 00       	call   80103d80 <wakeup>
  release(&log.lock);
80102bcd:	c7 04 24 40 f6 18 80 	movl   $0x8018f640,(%esp)
80102bd4:	e8 e7 16 00 00       	call   801042c0 <release>
80102bd9:	83 c4 10             	add    $0x10,%esp
}
80102bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdf:	5b                   	pop    %ebx
80102be0:	5e                   	pop    %esi
80102be1:	5f                   	pop    %edi
80102be2:	5d                   	pop    %ebp
80102be3:	c3                   	ret    
    panic("log.committing");
80102be4:	83 ec 0c             	sub    $0xc,%esp
80102be7:	68 04 73 10 80       	push   $0x80107304
80102bec:	e8 9f d7 ff ff       	call   80100390 <panic>
80102bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bff:	90                   	nop

80102c00 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c00:	f3 0f 1e fb          	endbr32 
80102c04:	55                   	push   %ebp
80102c05:	89 e5                	mov    %esp,%ebp
80102c07:	53                   	push   %ebx
80102c08:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c0b:	8b 15 88 f6 18 80    	mov    0x8018f688,%edx
{
80102c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c14:	83 fa 1d             	cmp    $0x1d,%edx
80102c17:	0f 8f 91 00 00 00    	jg     80102cae <log_write+0xae>
80102c1d:	a1 78 f6 18 80       	mov    0x8018f678,%eax
80102c22:	83 e8 01             	sub    $0x1,%eax
80102c25:	39 c2                	cmp    %eax,%edx
80102c27:	0f 8d 81 00 00 00    	jge    80102cae <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102c2d:	a1 7c f6 18 80       	mov    0x8018f67c,%eax
80102c32:	85 c0                	test   %eax,%eax
80102c34:	0f 8e 81 00 00 00    	jle    80102cbb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102c3a:	83 ec 0c             	sub    $0xc,%esp
80102c3d:	68 40 f6 18 80       	push   $0x8018f640
80102c42:	e8 b9 15 00 00       	call   80104200 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102c47:	8b 15 88 f6 18 80    	mov    0x8018f688,%edx
80102c4d:	83 c4 10             	add    $0x10,%esp
80102c50:	85 d2                	test   %edx,%edx
80102c52:	7e 4e                	jle    80102ca2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102c54:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c57:	31 c0                	xor    %eax,%eax
80102c59:	eb 0c                	jmp    80102c67 <log_write+0x67>
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
80102c60:	83 c0 01             	add    $0x1,%eax
80102c63:	39 c2                	cmp    %eax,%edx
80102c65:	74 29                	je     80102c90 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102c67:	39 0c 85 8c f6 18 80 	cmp    %ecx,-0x7fe70974(,%eax,4)
80102c6e:	75 f0                	jne    80102c60 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102c70:	89 0c 85 8c f6 18 80 	mov    %ecx,-0x7fe70974(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102c77:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102c7d:	c7 45 08 40 f6 18 80 	movl   $0x8018f640,0x8(%ebp)
}
80102c84:	c9                   	leave  
  release(&log.lock);
80102c85:	e9 36 16 00 00       	jmp    801042c0 <release>
80102c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102c90:	89 0c 95 8c f6 18 80 	mov    %ecx,-0x7fe70974(,%edx,4)
    log.lh.n++;
80102c97:	83 c2 01             	add    $0x1,%edx
80102c9a:	89 15 88 f6 18 80    	mov    %edx,0x8018f688
80102ca0:	eb d5                	jmp    80102c77 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102ca2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ca5:	a3 8c f6 18 80       	mov    %eax,0x8018f68c
  if (i == log.lh.n)
80102caa:	75 cb                	jne    80102c77 <log_write+0x77>
80102cac:	eb e9                	jmp    80102c97 <log_write+0x97>
    panic("too big a transaction");
80102cae:	83 ec 0c             	sub    $0xc,%esp
80102cb1:	68 13 73 10 80       	push   $0x80107313
80102cb6:	e8 d5 d6 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102cbb:	83 ec 0c             	sub    $0xc,%esp
80102cbe:	68 29 73 10 80       	push   $0x80107329
80102cc3:	e8 c8 d6 ff ff       	call   80100390 <panic>
80102cc8:	66 90                	xchg   %ax,%ax
80102cca:	66 90                	xchg   %ax,%ax
80102ccc:	66 90                	xchg   %ax,%ax
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102cd7:	e8 54 09 00 00       	call   80103630 <cpuid>
80102cdc:	89 c3                	mov    %eax,%ebx
80102cde:	e8 4d 09 00 00       	call   80103630 <cpuid>
80102ce3:	83 ec 04             	sub    $0x4,%esp
80102ce6:	53                   	push   %ebx
80102ce7:	50                   	push   %eax
80102ce8:	68 44 73 10 80       	push   $0x80107344
80102ced:	e8 be d9 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102cf2:	e8 09 29 00 00       	call   80105600 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102cf7:	e8 c4 08 00 00       	call   801035c0 <mycpu>
80102cfc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102cfe:	b8 01 00 00 00       	mov    $0x1,%eax
80102d03:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102d0a:	e8 01 0c 00 00       	call   80103910 <scheduler>
80102d0f:	90                   	nop

80102d10 <mpenter>:
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
80102d15:	89 e5                	mov    %esp,%ebp
80102d17:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102d1a:	e8 b1 39 00 00       	call   801066d0 <switchkvm>
  seginit();
80102d1f:	e8 1c 39 00 00       	call   80106640 <seginit>
  lapicinit();
80102d24:	e8 67 f7 ff ff       	call   80102490 <lapicinit>
  mpmain();
80102d29:	e8 a2 ff ff ff       	call   80102cd0 <mpmain>
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <main>:
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102d38:	83 e4 f0             	and    $0xfffffff0,%esp
80102d3b:	ff 71 fc             	pushl  -0x4(%ecx)
80102d3e:	55                   	push   %ebp
80102d3f:	89 e5                	mov    %esp,%ebp
80102d41:	53                   	push   %ebx
80102d42:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102d43:	83 ec 08             	sub    $0x8,%esp
80102d46:	68 00 00 40 80       	push   $0x80400000
80102d4b:	68 68 25 19 80       	push   $0x80192568
80102d50:	e8 fb f4 ff ff       	call   80102250 <kinit1>
  kvmalloc();      // kernel page table
80102d55:	e8 56 3e 00 00       	call   80106bb0 <kvmalloc>
  mpinit();        // detect other processors
80102d5a:	e8 81 01 00 00       	call   80102ee0 <mpinit>
  lapicinit();     // interrupt controller
80102d5f:	e8 2c f7 ff ff       	call   80102490 <lapicinit>
  seginit();       // segment descriptors
80102d64:	e8 d7 38 00 00       	call   80106640 <seginit>
  picinit();       // disable pic
80102d69:	e8 52 03 00 00       	call   801030c0 <picinit>
  ioapicinit();    // another interrupt controller
80102d6e:	e8 fd f2 ff ff       	call   80102070 <ioapicinit>
  consoleinit();   // console hardware
80102d73:	e8 b8 dc ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80102d78:	e8 83 2b 00 00       	call   80105900 <uartinit>
  pinit();         // process table
80102d7d:	e8 1e 08 00 00       	call   801035a0 <pinit>
  tvinit();        // trap vectors
80102d82:	e8 f9 27 00 00       	call   80105580 <tvinit>
  binit();         // buffer cache
80102d87:	e8 b4 d2 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102d8c:	e8 4f e0 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80102d91:	e8 2a 40 00 00       	call   80106dc0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102d96:	83 c4 0c             	add    $0xc,%esp
80102d99:	68 8a 00 00 00       	push   $0x8a
80102d9e:	68 8c a4 10 80       	push   $0x8010a48c
80102da3:	68 00 70 00 80       	push   $0x80007000
80102da8:	e8 03 16 00 00       	call   801043b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102dad:	83 c4 10             	add    $0x10,%esp
80102db0:	69 05 c0 fc 18 80 b0 	imul   $0xb0,0x8018fcc0,%eax
80102db7:	00 00 00 
80102dba:	05 40 f7 18 80       	add    $0x8018f740,%eax
80102dbf:	3d 40 f7 18 80       	cmp    $0x8018f740,%eax
80102dc4:	76 7a                	jbe    80102e40 <main+0x110>
80102dc6:	bb 40 f7 18 80       	mov    $0x8018f740,%ebx
80102dcb:	eb 1c                	jmp    80102de9 <main+0xb9>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
80102dd0:	69 05 c0 fc 18 80 b0 	imul   $0xb0,0x8018fcc0,%eax
80102dd7:	00 00 00 
80102dda:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102de0:	05 40 f7 18 80       	add    $0x8018f740,%eax
80102de5:	39 c3                	cmp    %eax,%ebx
80102de7:	73 57                	jae    80102e40 <main+0x110>
    if(c == mycpu())  // We've started already.
80102de9:	e8 d2 07 00 00       	call   801035c0 <mycpu>
80102dee:	39 c3                	cmp    %eax,%ebx
80102df0:	74 de                	je     80102dd0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102df2:	e8 29 f5 ff ff       	call   80102320 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102df7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80102dfa:	c7 05 f8 6f 00 80 10 	movl   $0x80102d10,0x80006ff8
80102e01:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e04:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e0b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e0e:	05 00 10 00 00       	add    $0x1000,%eax
80102e13:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80102e18:	0f b6 03             	movzbl (%ebx),%eax
80102e1b:	68 00 70 00 00       	push   $0x7000
80102e20:	50                   	push   %eax
80102e21:	e8 ba f7 ff ff       	call   801025e0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102e26:	83 c4 10             	add    $0x10,%esp
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102e36:	85 c0                	test   %eax,%eax
80102e38:	74 f6                	je     80102e30 <main+0x100>
80102e3a:	eb 94                	jmp    80102dd0 <main+0xa0>
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102e40:	83 ec 08             	sub    $0x8,%esp
80102e43:	68 00 00 00 8e       	push   $0x8e000000
80102e48:	68 00 00 40 80       	push   $0x80400000
80102e4d:	e8 6e f4 ff ff       	call   801022c0 <kinit2>
  userinit();      // first user process
80102e52:	e8 29 08 00 00       	call   80103680 <userinit>
  mpmain();        // finish this processor's setup
80102e57:	e8 74 fe ff ff       	call   80102cd0 <mpmain>
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	57                   	push   %edi
80102e64:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102e65:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102e6b:	53                   	push   %ebx
  e = addr+len;
80102e6c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102e6f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102e72:	39 de                	cmp    %ebx,%esi
80102e74:	72 10                	jb     80102e86 <mpsearch1+0x26>
80102e76:	eb 50                	jmp    80102ec8 <mpsearch1+0x68>
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
80102e80:	89 fe                	mov    %edi,%esi
80102e82:	39 fb                	cmp    %edi,%ebx
80102e84:	76 42                	jbe    80102ec8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102e86:	83 ec 04             	sub    $0x4,%esp
80102e89:	8d 7e 10             	lea    0x10(%esi),%edi
80102e8c:	6a 04                	push   $0x4
80102e8e:	68 58 73 10 80       	push   $0x80107358
80102e93:	56                   	push   %esi
80102e94:	e8 c7 14 00 00       	call   80104360 <memcmp>
80102e99:	83 c4 10             	add    $0x10,%esp
80102e9c:	85 c0                	test   %eax,%eax
80102e9e:	75 e0                	jne    80102e80 <mpsearch1+0x20>
80102ea0:	89 f2                	mov    %esi,%edx
80102ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80102ea8:	0f b6 0a             	movzbl (%edx),%ecx
80102eab:	83 c2 01             	add    $0x1,%edx
80102eae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102eb0:	39 fa                	cmp    %edi,%edx
80102eb2:	75 f4                	jne    80102ea8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102eb4:	84 c0                	test   %al,%al
80102eb6:	75 c8                	jne    80102e80 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80102eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ebb:	89 f0                	mov    %esi,%eax
80102ebd:	5b                   	pop    %ebx
80102ebe:	5e                   	pop    %esi
80102ebf:	5f                   	pop    %edi
80102ec0:	5d                   	pop    %ebp
80102ec1:	c3                   	ret    
80102ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102ecb:	31 f6                	xor    %esi,%esi
}
80102ecd:	5b                   	pop    %ebx
80102ece:	89 f0                	mov    %esi,%eax
80102ed0:	5e                   	pop    %esi
80102ed1:	5f                   	pop    %edi
80102ed2:	5d                   	pop    %ebp
80102ed3:	c3                   	ret    
80102ed4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop

80102ee0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ee0:	f3 0f 1e fb          	endbr32 
80102ee4:	55                   	push   %ebp
80102ee5:	89 e5                	mov    %esp,%ebp
80102ee7:	57                   	push   %edi
80102ee8:	56                   	push   %esi
80102ee9:	53                   	push   %ebx
80102eea:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102eed:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ef4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102efb:	c1 e0 08             	shl    $0x8,%eax
80102efe:	09 d0                	or     %edx,%eax
80102f00:	c1 e0 04             	shl    $0x4,%eax
80102f03:	75 1b                	jne    80102f20 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102f05:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102f0c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102f13:	c1 e0 08             	shl    $0x8,%eax
80102f16:	09 d0                	or     %edx,%eax
80102f18:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102f1b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102f20:	ba 00 04 00 00       	mov    $0x400,%edx
80102f25:	e8 36 ff ff ff       	call   80102e60 <mpsearch1>
80102f2a:	89 c6                	mov    %eax,%esi
80102f2c:	85 c0                	test   %eax,%eax
80102f2e:	0f 84 4c 01 00 00    	je     80103080 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102f34:	8b 5e 04             	mov    0x4(%esi),%ebx
80102f37:	85 db                	test   %ebx,%ebx
80102f39:	0f 84 61 01 00 00    	je     801030a0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80102f3f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102f42:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102f48:	6a 04                	push   $0x4
80102f4a:	68 5d 73 10 80       	push   $0x8010735d
80102f4f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102f50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102f53:	e8 08 14 00 00       	call   80104360 <memcmp>
80102f58:	83 c4 10             	add    $0x10,%esp
80102f5b:	85 c0                	test   %eax,%eax
80102f5d:	0f 85 3d 01 00 00    	jne    801030a0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80102f63:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102f6a:	3c 01                	cmp    $0x1,%al
80102f6c:	74 08                	je     80102f76 <mpinit+0x96>
80102f6e:	3c 04                	cmp    $0x4,%al
80102f70:	0f 85 2a 01 00 00    	jne    801030a0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80102f76:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80102f7d:	66 85 d2             	test   %dx,%dx
80102f80:	74 26                	je     80102fa8 <mpinit+0xc8>
80102f82:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80102f85:	89 d8                	mov    %ebx,%eax
  sum = 0;
80102f87:	31 d2                	xor    %edx,%edx
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80102f90:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80102f97:	83 c0 01             	add    $0x1,%eax
80102f9a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102f9c:	39 f8                	cmp    %edi,%eax
80102f9e:	75 f0                	jne    80102f90 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80102fa0:	84 d2                	test   %dl,%dl
80102fa2:	0f 85 f8 00 00 00    	jne    801030a0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102fa8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102fae:	a3 3c f6 18 80       	mov    %eax,0x8018f63c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fb3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80102fb9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80102fc0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fc5:	03 55 e4             	add    -0x1c(%ebp),%edx
80102fc8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
80102fd0:	39 c2                	cmp    %eax,%edx
80102fd2:	76 15                	jbe    80102fe9 <mpinit+0x109>
    switch(*p){
80102fd4:	0f b6 08             	movzbl (%eax),%ecx
80102fd7:	80 f9 02             	cmp    $0x2,%cl
80102fda:	74 5c                	je     80103038 <mpinit+0x158>
80102fdc:	77 42                	ja     80103020 <mpinit+0x140>
80102fde:	84 c9                	test   %cl,%cl
80102fe0:	74 6e                	je     80103050 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102fe2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fe5:	39 c2                	cmp    %eax,%edx
80102fe7:	77 eb                	ja     80102fd4 <mpinit+0xf4>
80102fe9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102fec:	85 db                	test   %ebx,%ebx
80102fee:	0f 84 b9 00 00 00    	je     801030ad <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102ff4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80102ff8:	74 15                	je     8010300f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ffa:	b8 70 00 00 00       	mov    $0x70,%eax
80102fff:	ba 22 00 00 00       	mov    $0x22,%edx
80103004:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103005:	ba 23 00 00 00       	mov    $0x23,%edx
8010300a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010300b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010300e:	ee                   	out    %al,(%dx)
  }
}
8010300f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103012:	5b                   	pop    %ebx
80103013:	5e                   	pop    %esi
80103014:	5f                   	pop    %edi
80103015:	5d                   	pop    %ebp
80103016:	c3                   	ret    
80103017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103020:	83 e9 03             	sub    $0x3,%ecx
80103023:	80 f9 01             	cmp    $0x1,%cl
80103026:	76 ba                	jbe    80102fe2 <mpinit+0x102>
80103028:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010302f:	eb 9f                	jmp    80102fd0 <mpinit+0xf0>
80103031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103038:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010303c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010303f:	88 0d 20 f7 18 80    	mov    %cl,0x8018f720
      continue;
80103045:	eb 89                	jmp    80102fd0 <mpinit+0xf0>
80103047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103050:	8b 0d c0 fc 18 80    	mov    0x8018fcc0,%ecx
80103056:	83 f9 07             	cmp    $0x7,%ecx
80103059:	7f 19                	jg     80103074 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010305b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103061:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103065:	83 c1 01             	add    $0x1,%ecx
80103068:	89 0d c0 fc 18 80    	mov    %ecx,0x8018fcc0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010306e:	88 9f 40 f7 18 80    	mov    %bl,-0x7fe708c0(%edi)
      p += sizeof(struct mpproc);
80103074:	83 c0 14             	add    $0x14,%eax
      continue;
80103077:	e9 54 ff ff ff       	jmp    80102fd0 <mpinit+0xf0>
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103080:	ba 00 00 01 00       	mov    $0x10000,%edx
80103085:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010308a:	e8 d1 fd ff ff       	call   80102e60 <mpsearch1>
8010308f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103091:	85 c0                	test   %eax,%eax
80103093:	0f 85 9b fe ff ff    	jne    80102f34 <mpinit+0x54>
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801030a0:	83 ec 0c             	sub    $0xc,%esp
801030a3:	68 62 73 10 80       	push   $0x80107362
801030a8:	e8 e3 d2 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801030ad:	83 ec 0c             	sub    $0xc,%esp
801030b0:	68 7c 73 10 80       	push   $0x8010737c
801030b5:	e8 d6 d2 ff ff       	call   80100390 <panic>
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801030c0:	f3 0f 1e fb          	endbr32 
801030c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030c9:	ba 21 00 00 00       	mov    $0x21,%edx
801030ce:	ee                   	out    %al,(%dx)
801030cf:	ba a1 00 00 00       	mov    $0xa1,%edx
801030d4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801030d5:	c3                   	ret    
801030d6:	66 90                	xchg   %ax,%ax
801030d8:	66 90                	xchg   %ax,%ax
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801030e0:	f3 0f 1e fb          	endbr32 
801030e4:	55                   	push   %ebp
801030e5:	89 e5                	mov    %esp,%ebp
801030e7:	57                   	push   %edi
801030e8:	56                   	push   %esi
801030e9:	53                   	push   %ebx
801030ea:	83 ec 0c             	sub    $0xc,%esp
801030ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
801030f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801030f3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801030f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801030ff:	e8 fc dc ff ff       	call   80100e00 <filealloc>
80103104:	89 03                	mov    %eax,(%ebx)
80103106:	85 c0                	test   %eax,%eax
80103108:	0f 84 ac 00 00 00    	je     801031ba <pipealloc+0xda>
8010310e:	e8 ed dc ff ff       	call   80100e00 <filealloc>
80103113:	89 06                	mov    %eax,(%esi)
80103115:	85 c0                	test   %eax,%eax
80103117:	0f 84 8b 00 00 00    	je     801031a8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010311d:	e8 fe f1 ff ff       	call   80102320 <kalloc>
80103122:	89 c7                	mov    %eax,%edi
80103124:	85 c0                	test   %eax,%eax
80103126:	0f 84 b4 00 00 00    	je     801031e0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010312c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103133:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103136:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103139:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103140:	00 00 00 
  p->nwrite = 0;
80103143:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010314a:	00 00 00 
  p->nread = 0;
8010314d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103154:	00 00 00 
  initlock(&p->lock, "pipe");
80103157:	68 9b 73 10 80       	push   $0x8010739b
8010315c:	50                   	push   %eax
8010315d:	e8 1e 0f 00 00       	call   80104080 <initlock>
  (*f0)->type = FD_PIPE;
80103162:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103164:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103167:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010316d:	8b 03                	mov    (%ebx),%eax
8010316f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103173:	8b 03                	mov    (%ebx),%eax
80103175:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103179:	8b 03                	mov    (%ebx),%eax
8010317b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010317e:	8b 06                	mov    (%esi),%eax
80103180:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103186:	8b 06                	mov    (%esi),%eax
80103188:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010318c:	8b 06                	mov    (%esi),%eax
8010318e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103192:	8b 06                	mov    (%esi),%eax
80103194:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103197:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010319a:	31 c0                	xor    %eax,%eax
}
8010319c:	5b                   	pop    %ebx
8010319d:	5e                   	pop    %esi
8010319e:	5f                   	pop    %edi
8010319f:	5d                   	pop    %ebp
801031a0:	c3                   	ret    
801031a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801031a8:	8b 03                	mov    (%ebx),%eax
801031aa:	85 c0                	test   %eax,%eax
801031ac:	74 1e                	je     801031cc <pipealloc+0xec>
    fileclose(*f0);
801031ae:	83 ec 0c             	sub    $0xc,%esp
801031b1:	50                   	push   %eax
801031b2:	e8 09 dd ff ff       	call   80100ec0 <fileclose>
801031b7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801031ba:	8b 06                	mov    (%esi),%eax
801031bc:	85 c0                	test   %eax,%eax
801031be:	74 0c                	je     801031cc <pipealloc+0xec>
    fileclose(*f1);
801031c0:	83 ec 0c             	sub    $0xc,%esp
801031c3:	50                   	push   %eax
801031c4:	e8 f7 dc ff ff       	call   80100ec0 <fileclose>
801031c9:	83 c4 10             	add    $0x10,%esp
}
801031cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801031cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801031d4:	5b                   	pop    %ebx
801031d5:	5e                   	pop    %esi
801031d6:	5f                   	pop    %edi
801031d7:	5d                   	pop    %ebp
801031d8:	c3                   	ret    
801031d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801031e0:	8b 03                	mov    (%ebx),%eax
801031e2:	85 c0                	test   %eax,%eax
801031e4:	75 c8                	jne    801031ae <pipealloc+0xce>
801031e6:	eb d2                	jmp    801031ba <pipealloc+0xda>
801031e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	56                   	push   %esi
801031f8:	53                   	push   %ebx
801031f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801031ff:	83 ec 0c             	sub    $0xc,%esp
80103202:	53                   	push   %ebx
80103203:	e8 f8 0f 00 00       	call   80104200 <acquire>
  if(writable){
80103208:	83 c4 10             	add    $0x10,%esp
8010320b:	85 f6                	test   %esi,%esi
8010320d:	74 41                	je     80103250 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010320f:	83 ec 0c             	sub    $0xc,%esp
80103212:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103218:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010321f:	00 00 00 
    wakeup(&p->nread);
80103222:	50                   	push   %eax
80103223:	e8 58 0b 00 00       	call   80103d80 <wakeup>
80103228:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010322b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103231:	85 d2                	test   %edx,%edx
80103233:	75 0a                	jne    8010323f <pipeclose+0x4f>
80103235:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010323b:	85 c0                	test   %eax,%eax
8010323d:	74 31                	je     80103270 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010323f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103242:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103245:	5b                   	pop    %ebx
80103246:	5e                   	pop    %esi
80103247:	5d                   	pop    %ebp
    release(&p->lock);
80103248:	e9 73 10 00 00       	jmp    801042c0 <release>
8010324d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103259:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103260:	00 00 00 
    wakeup(&p->nwrite);
80103263:	50                   	push   %eax
80103264:	e8 17 0b 00 00       	call   80103d80 <wakeup>
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	eb bd                	jmp    8010322b <pipeclose+0x3b>
8010326e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103270:	83 ec 0c             	sub    $0xc,%esp
80103273:	53                   	push   %ebx
80103274:	e8 47 10 00 00       	call   801042c0 <release>
    kfree((char*)p);
80103279:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010327c:	83 c4 10             	add    $0x10,%esp
}
8010327f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103282:	5b                   	pop    %ebx
80103283:	5e                   	pop    %esi
80103284:	5d                   	pop    %ebp
    kfree((char*)p);
80103285:	e9 d6 ee ff ff       	jmp    80102160 <kfree>
8010328a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103290 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103290:	f3 0f 1e fb          	endbr32 
80103294:	55                   	push   %ebp
80103295:	89 e5                	mov    %esp,%ebp
80103297:	57                   	push   %edi
80103298:	56                   	push   %esi
80103299:	53                   	push   %ebx
8010329a:	83 ec 28             	sub    $0x28,%esp
8010329d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032a0:	53                   	push   %ebx
801032a1:	e8 5a 0f 00 00       	call   80104200 <acquire>
  for(i = 0; i < n; i++){
801032a6:	8b 45 10             	mov    0x10(%ebp),%eax
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	85 c0                	test   %eax,%eax
801032ae:	0f 8e bc 00 00 00    	jle    80103370 <pipewrite+0xe0>
801032b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801032b7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801032bd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801032c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032c6:	03 45 10             	add    0x10(%ebp),%eax
801032c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032cc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032d2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032d8:	89 ca                	mov    %ecx,%edx
801032da:	05 00 02 00 00       	add    $0x200,%eax
801032df:	39 c1                	cmp    %eax,%ecx
801032e1:	74 3b                	je     8010331e <pipewrite+0x8e>
801032e3:	eb 63                	jmp    80103348 <pipewrite+0xb8>
801032e5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801032e8:	e8 63 03 00 00       	call   80103650 <myproc>
801032ed:	8b 48 28             	mov    0x28(%eax),%ecx
801032f0:	85 c9                	test   %ecx,%ecx
801032f2:	75 34                	jne    80103328 <pipewrite+0x98>
      wakeup(&p->nread);
801032f4:	83 ec 0c             	sub    $0xc,%esp
801032f7:	57                   	push   %edi
801032f8:	e8 83 0a 00 00       	call   80103d80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032fd:	58                   	pop    %eax
801032fe:	5a                   	pop    %edx
801032ff:	53                   	push   %ebx
80103300:	56                   	push   %esi
80103301:	e8 ca 08 00 00       	call   80103bd0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103306:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010330c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103312:	83 c4 10             	add    $0x10,%esp
80103315:	05 00 02 00 00       	add    $0x200,%eax
8010331a:	39 c2                	cmp    %eax,%edx
8010331c:	75 2a                	jne    80103348 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010331e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103324:	85 c0                	test   %eax,%eax
80103326:	75 c0                	jne    801032e8 <pipewrite+0x58>
        release(&p->lock);
80103328:	83 ec 0c             	sub    $0xc,%esp
8010332b:	53                   	push   %ebx
8010332c:	e8 8f 0f 00 00       	call   801042c0 <release>
        return -1;
80103331:	83 c4 10             	add    $0x10,%esp
80103334:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103339:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333c:	5b                   	pop    %ebx
8010333d:	5e                   	pop    %esi
8010333e:	5f                   	pop    %edi
8010333f:	5d                   	pop    %ebp
80103340:	c3                   	ret    
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103348:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010334b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010334e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103354:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010335a:	0f b6 06             	movzbl (%esi),%eax
8010335d:	83 c6 01             	add    $0x1,%esi
80103360:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103363:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103367:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010336a:	0f 85 5c ff ff ff    	jne    801032cc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103379:	50                   	push   %eax
8010337a:	e8 01 0a 00 00       	call   80103d80 <wakeup>
  release(&p->lock);
8010337f:	89 1c 24             	mov    %ebx,(%esp)
80103382:	e8 39 0f 00 00       	call   801042c0 <release>
  return n;
80103387:	8b 45 10             	mov    0x10(%ebp),%eax
8010338a:	83 c4 10             	add    $0x10,%esp
8010338d:	eb aa                	jmp    80103339 <pipewrite+0xa9>
8010338f:	90                   	nop

80103390 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103390:	f3 0f 1e fb          	endbr32 
80103394:	55                   	push   %ebp
80103395:	89 e5                	mov    %esp,%ebp
80103397:	57                   	push   %edi
80103398:	56                   	push   %esi
80103399:	53                   	push   %ebx
8010339a:	83 ec 18             	sub    $0x18,%esp
8010339d:	8b 75 08             	mov    0x8(%ebp),%esi
801033a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033a3:	56                   	push   %esi
801033a4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801033aa:	e8 51 0e 00 00       	call   80104200 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033af:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033b5:	83 c4 10             	add    $0x10,%esp
801033b8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801033be:	74 33                	je     801033f3 <piperead+0x63>
801033c0:	eb 3b                	jmp    801033fd <piperead+0x6d>
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801033c8:	e8 83 02 00 00       	call   80103650 <myproc>
801033cd:	8b 48 28             	mov    0x28(%eax),%ecx
801033d0:	85 c9                	test   %ecx,%ecx
801033d2:	0f 85 88 00 00 00    	jne    80103460 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033d8:	83 ec 08             	sub    $0x8,%esp
801033db:	56                   	push   %esi
801033dc:	53                   	push   %ebx
801033dd:	e8 ee 07 00 00       	call   80103bd0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033e2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801033e8:	83 c4 10             	add    $0x10,%esp
801033eb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801033f1:	75 0a                	jne    801033fd <piperead+0x6d>
801033f3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801033f9:	85 c0                	test   %eax,%eax
801033fb:	75 cb                	jne    801033c8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801033fd:	8b 55 10             	mov    0x10(%ebp),%edx
80103400:	31 db                	xor    %ebx,%ebx
80103402:	85 d2                	test   %edx,%edx
80103404:	7f 28                	jg     8010342e <piperead+0x9e>
80103406:	eb 34                	jmp    8010343c <piperead+0xac>
80103408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103410:	8d 48 01             	lea    0x1(%eax),%ecx
80103413:	25 ff 01 00 00       	and    $0x1ff,%eax
80103418:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010341e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103423:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103426:	83 c3 01             	add    $0x1,%ebx
80103429:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010342c:	74 0e                	je     8010343c <piperead+0xac>
    if(p->nread == p->nwrite)
8010342e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103434:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010343a:	75 d4                	jne    80103410 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010343c:	83 ec 0c             	sub    $0xc,%esp
8010343f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103445:	50                   	push   %eax
80103446:	e8 35 09 00 00       	call   80103d80 <wakeup>
  release(&p->lock);
8010344b:	89 34 24             	mov    %esi,(%esp)
8010344e:	e8 6d 0e 00 00       	call   801042c0 <release>
  return i;
80103453:	83 c4 10             	add    $0x10,%esp
}
80103456:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103459:	89 d8                	mov    %ebx,%eax
8010345b:	5b                   	pop    %ebx
8010345c:	5e                   	pop    %esi
8010345d:	5f                   	pop    %edi
8010345e:	5d                   	pop    %ebp
8010345f:	c3                   	ret    
      release(&p->lock);
80103460:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103463:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103468:	56                   	push   %esi
80103469:	e8 52 0e 00 00       	call   801042c0 <release>
      return -1;
8010346e:	83 c4 10             	add    $0x10,%esp
}
80103471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103474:	89 d8                	mov    %ebx,%eax
80103476:	5b                   	pop    %ebx
80103477:	5e                   	pop    %esi
80103478:	5f                   	pop    %edi
80103479:	5d                   	pop    %ebp
8010347a:	c3                   	ret    
8010347b:	66 90                	xchg   %ax,%ax
8010347d:	66 90                	xchg   %ax,%ax
8010347f:	90                   	nop

80103480 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103484:	bb 14 fd 18 80       	mov    $0x8018fd14,%ebx
{
80103489:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010348c:	68 e0 fc 18 80       	push   $0x8018fce0
80103491:	e8 6a 0d 00 00       	call   80104200 <acquire>
80103496:	83 c4 10             	add    $0x10,%esp
80103499:	eb 10                	jmp    801034ab <allocproc+0x2b>
8010349b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010349f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034a0:	83 eb 80             	sub    $0xffffff80,%ebx
801034a3:	81 fb 14 1d 19 80    	cmp    $0x80191d14,%ebx
801034a9:	74 75                	je     80103520 <allocproc+0xa0>
    if(p->state == UNUSED)
801034ab:	8b 43 10             	mov    0x10(%ebx),%eax
801034ae:	85 c0                	test   %eax,%eax
801034b0:	75 ee                	jne    801034a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034b2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801034ba:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801034c1:	89 43 14             	mov    %eax,0x14(%ebx)
801034c4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801034c7:	68 e0 fc 18 80       	push   $0x8018fce0
  p->pid = nextpid++;
801034cc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801034d2:	e8 e9 0d 00 00       	call   801042c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801034d7:	e8 44 ee ff ff       	call   80102320 <kalloc>
801034dc:	83 c4 10             	add    $0x10,%esp
801034df:	89 43 0c             	mov    %eax,0xc(%ebx)
801034e2:	85 c0                	test   %eax,%eax
801034e4:	74 53                	je     80103539 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801034e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801034ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801034ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801034f4:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801034f7:	c7 40 14 66 55 10 80 	movl   $0x80105566,0x14(%eax)
  p->context = (struct context*)sp;
801034fe:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103501:	6a 14                	push   $0x14
80103503:	6a 00                	push   $0x0
80103505:	50                   	push   %eax
80103506:	e8 05 0e 00 00       	call   80104310 <memset>
  p->context->eip = (uint)forkret;
8010350b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
8010350e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103511:	c7 40 10 50 35 10 80 	movl   $0x80103550,0x10(%eax)
}
80103518:	89 d8                	mov    %ebx,%eax
8010351a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010351d:	c9                   	leave  
8010351e:	c3                   	ret    
8010351f:	90                   	nop
  release(&ptable.lock);
80103520:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103523:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103525:	68 e0 fc 18 80       	push   $0x8018fce0
8010352a:	e8 91 0d 00 00       	call   801042c0 <release>
}
8010352f:	89 d8                	mov    %ebx,%eax
  return 0;
80103531:	83 c4 10             	add    $0x10,%esp
}
80103534:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103537:	c9                   	leave  
80103538:	c3                   	ret    
    p->state = UNUSED;
80103539:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103540:	31 db                	xor    %ebx,%ebx
}
80103542:	89 d8                	mov    %ebx,%eax
80103544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103547:	c9                   	leave  
80103548:	c3                   	ret    
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103550 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103550:	f3 0f 1e fb          	endbr32 
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010355a:	68 e0 fc 18 80       	push   $0x8018fce0
8010355f:	e8 5c 0d 00 00       	call   801042c0 <release>

  if (first) {
80103564:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	85 c0                	test   %eax,%eax
8010356e:	75 08                	jne    80103578 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103570:	c9                   	leave  
80103571:	c3                   	ret    
80103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103578:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010357f:	00 00 00 
    iinit(ROOTDEV);
80103582:	83 ec 0c             	sub    $0xc,%esp
80103585:	6a 01                	push   $0x1
80103587:	e8 b4 df ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010358c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103593:	e8 e8 f3 ff ff       	call   80102980 <initlog>
}
80103598:	83 c4 10             	add    $0x10,%esp
8010359b:	c9                   	leave  
8010359c:	c3                   	ret    
8010359d:	8d 76 00             	lea    0x0(%esi),%esi

801035a0 <pinit>:
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801035aa:	68 a0 73 10 80       	push   $0x801073a0
801035af:	68 e0 fc 18 80       	push   $0x8018fce0
801035b4:	e8 c7 0a 00 00       	call   80104080 <initlock>
}
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	c9                   	leave  
801035bd:	c3                   	ret    
801035be:	66 90                	xchg   %ax,%ax

801035c0 <mycpu>:
{
801035c0:	f3 0f 1e fb          	endbr32 
801035c4:	55                   	push   %ebp
801035c5:	89 e5                	mov    %esp,%ebp
801035c7:	56                   	push   %esi
801035c8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035c9:	9c                   	pushf  
801035ca:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035cb:	f6 c4 02             	test   $0x2,%ah
801035ce:	75 4a                	jne    8010361a <mycpu+0x5a>
  apicid = lapicid();
801035d0:	e8 bb ef ff ff       	call   80102590 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801035d5:	8b 35 c0 fc 18 80    	mov    0x8018fcc0,%esi
  apicid = lapicid();
801035db:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801035dd:	85 f6                	test   %esi,%esi
801035df:	7e 2c                	jle    8010360d <mycpu+0x4d>
801035e1:	31 d2                	xor    %edx,%edx
801035e3:	eb 0a                	jmp    801035ef <mycpu+0x2f>
801035e5:	8d 76 00             	lea    0x0(%esi),%esi
801035e8:	83 c2 01             	add    $0x1,%edx
801035eb:	39 f2                	cmp    %esi,%edx
801035ed:	74 1e                	je     8010360d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801035ef:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801035f5:	0f b6 81 40 f7 18 80 	movzbl -0x7fe708c0(%ecx),%eax
801035fc:	39 d8                	cmp    %ebx,%eax
801035fe:	75 e8                	jne    801035e8 <mycpu+0x28>
}
80103600:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103603:	8d 81 40 f7 18 80    	lea    -0x7fe708c0(%ecx),%eax
}
80103609:	5b                   	pop    %ebx
8010360a:	5e                   	pop    %esi
8010360b:	5d                   	pop    %ebp
8010360c:	c3                   	ret    
  panic("unknown apicid\n");
8010360d:	83 ec 0c             	sub    $0xc,%esp
80103610:	68 a7 73 10 80       	push   $0x801073a7
80103615:	e8 76 cd ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010361a:	83 ec 0c             	sub    $0xc,%esp
8010361d:	68 84 74 10 80       	push   $0x80107484
80103622:	e8 69 cd ff ff       	call   80100390 <panic>
80103627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010362e:	66 90                	xchg   %ax,%ax

80103630 <cpuid>:
cpuid() {
80103630:	f3 0f 1e fb          	endbr32 
80103634:	55                   	push   %ebp
80103635:	89 e5                	mov    %esp,%ebp
80103637:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010363a:	e8 81 ff ff ff       	call   801035c0 <mycpu>
}
8010363f:	c9                   	leave  
  return mycpu()-cpus;
80103640:	2d 40 f7 18 80       	sub    $0x8018f740,%eax
80103645:	c1 f8 04             	sar    $0x4,%eax
80103648:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010364e:	c3                   	ret    
8010364f:	90                   	nop

80103650 <myproc>:
myproc(void) {
80103650:	f3 0f 1e fb          	endbr32 
80103654:	55                   	push   %ebp
80103655:	89 e5                	mov    %esp,%ebp
80103657:	53                   	push   %ebx
80103658:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010365b:	e8 a0 0a 00 00       	call   80104100 <pushcli>
  c = mycpu();
80103660:	e8 5b ff ff ff       	call   801035c0 <mycpu>
  p = c->proc;
80103665:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  p->readid = 0; //initialize readcount to zero
8010366b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103671:	e8 da 0a 00 00       	call   80104150 <popcli>
}
80103676:	83 c4 04             	add    $0x4,%esp
80103679:	89 d8                	mov    %ebx,%eax
8010367b:	5b                   	pop    %ebx
8010367c:	5d                   	pop    %ebp
8010367d:	c3                   	ret    
8010367e:	66 90                	xchg   %ax,%ax

80103680 <userinit>:
{
80103680:	f3 0f 1e fb          	endbr32 
80103684:	55                   	push   %ebp
80103685:	89 e5                	mov    %esp,%ebp
80103687:	53                   	push   %ebx
80103688:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010368b:	e8 f0 fd ff ff       	call   80103480 <allocproc>
80103690:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103692:	a3 60 75 18 80       	mov    %eax,0x80187560
  if((p->pgdir = setupkvm()) == 0)
80103697:	e8 94 34 00 00       	call   80106b30 <setupkvm>
8010369c:	89 43 08             	mov    %eax,0x8(%ebx)
8010369f:	85 c0                	test   %eax,%eax
801036a1:	0f 84 be 00 00 00    	je     80103765 <userinit+0xe5>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036a7:	83 ec 04             	sub    $0x4,%esp
801036aa:	68 2c 00 00 00       	push   $0x2c
801036af:	68 60 a4 10 80       	push   $0x8010a460
801036b4:	50                   	push   %eax
801036b5:	e8 46 31 00 00       	call   80106800 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801036ba:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801036bd:	c7 43 04 00 10 00 00 	movl   $0x1000,0x4(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801036c4:	6a 4c                	push   $0x4c
801036c6:	6a 00                	push   $0x0
801036c8:	ff 73 1c             	pushl  0x1c(%ebx)
801036cb:	e8 40 0c 00 00       	call   80104310 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801036d0:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036d3:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801036d8:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801036db:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801036e0:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801036e4:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036e7:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801036eb:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036ee:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801036f2:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801036f6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801036fd:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103701:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103704:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010370b:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010370e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103715:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103718:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010371f:	8d 43 70             	lea    0x70(%ebx),%eax
80103722:	6a 10                	push   $0x10
80103724:	68 d0 73 10 80       	push   $0x801073d0
80103729:	50                   	push   %eax
8010372a:	e8 a1 0d 00 00       	call   801044d0 <safestrcpy>
  p->cwd = namei("/");
8010372f:	c7 04 24 d9 73 10 80 	movl   $0x801073d9,(%esp)
80103736:	e8 f5 e8 ff ff       	call   80102030 <namei>
8010373b:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
8010373e:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
80103745:	e8 b6 0a 00 00       	call   80104200 <acquire>
  p->state = RUNNABLE;
8010374a:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103751:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
80103758:	e8 63 0b 00 00       	call   801042c0 <release>
}
8010375d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103760:	83 c4 10             	add    $0x10,%esp
80103763:	c9                   	leave  
80103764:	c3                   	ret    
    panic("userinit: out of memory?");
80103765:	83 ec 0c             	sub    $0xc,%esp
80103768:	68 b7 73 10 80       	push   $0x801073b7
8010376d:	e8 1e cc ff ff       	call   80100390 <panic>
80103772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103780 <growproc>:
{
80103780:	f3 0f 1e fb          	endbr32 
80103784:	55                   	push   %ebp
80103785:	89 e5                	mov    %esp,%ebp
80103787:	56                   	push   %esi
80103788:	53                   	push   %ebx
80103789:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010378c:	e8 bf fe ff ff       	call   80103650 <myproc>
80103791:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103793:	8b 40 04             	mov    0x4(%eax),%eax
  if(n > 0){
80103796:	85 f6                	test   %esi,%esi
80103798:	7f 1e                	jg     801037b8 <growproc+0x38>
  } else if(n < 0){
8010379a:	75 3c                	jne    801037d8 <growproc+0x58>
  switchuvm(curproc);
8010379c:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010379f:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
801037a2:	53                   	push   %ebx
801037a3:	e8 48 2f 00 00       	call   801066f0 <switchuvm>
  return 0;
801037a8:	83 c4 10             	add    $0x10,%esp
801037ab:	31 c0                	xor    %eax,%eax
}
801037ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b0:	5b                   	pop    %ebx
801037b1:	5e                   	pop    %esi
801037b2:	5d                   	pop    %ebp
801037b3:	c3                   	ret    
801037b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037b8:	83 ec 04             	sub    $0x4,%esp
801037bb:	01 c6                	add    %eax,%esi
801037bd:	56                   	push   %esi
801037be:	50                   	push   %eax
801037bf:	ff 73 08             	pushl  0x8(%ebx)
801037c2:	e8 89 31 00 00       	call   80106950 <allocuvm>
801037c7:	83 c4 10             	add    $0x10,%esp
801037ca:	85 c0                	test   %eax,%eax
801037cc:	75 ce                	jne    8010379c <growproc+0x1c>
      return -1;
801037ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037d3:	eb d8                	jmp    801037ad <growproc+0x2d>
801037d5:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037d8:	83 ec 04             	sub    $0x4,%esp
801037db:	01 c6                	add    %eax,%esi
801037dd:	56                   	push   %esi
801037de:	50                   	push   %eax
801037df:	ff 73 08             	pushl  0x8(%ebx)
801037e2:	e8 99 32 00 00       	call   80106a80 <deallocuvm>
801037e7:	83 c4 10             	add    $0x10,%esp
801037ea:	85 c0                	test   %eax,%eax
801037ec:	75 ae                	jne    8010379c <growproc+0x1c>
801037ee:	eb de                	jmp    801037ce <growproc+0x4e>

801037f0 <fork>:
{
801037f0:	f3 0f 1e fb          	endbr32 
801037f4:	55                   	push   %ebp
801037f5:	89 e5                	mov    %esp,%ebp
801037f7:	57                   	push   %edi
801037f8:	56                   	push   %esi
801037f9:	53                   	push   %ebx
801037fa:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801037fd:	e8 4e fe ff ff       	call   80103650 <myproc>
80103802:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103804:	e8 77 fc ff ff       	call   80103480 <allocproc>
80103809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010380c:	85 c0                	test   %eax,%eax
8010380e:	0f 84 c1 00 00 00    	je     801038d5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103814:	83 ec 08             	sub    $0x8,%esp
80103817:	ff 73 04             	pushl  0x4(%ebx)
8010381a:	89 c7                	mov    %eax,%edi
8010381c:	ff 73 08             	pushl  0x8(%ebx)
8010381f:	e8 dc 33 00 00       	call   80106c00 <copyuvm>
80103824:	83 c4 10             	add    $0x10,%esp
80103827:	89 47 08             	mov    %eax,0x8(%edi)
8010382a:	85 c0                	test   %eax,%eax
8010382c:	0f 84 aa 00 00 00    	je     801038dc <fork+0xec>
  np->sz = curproc->sz;
80103832:	8b 43 04             	mov    0x4(%ebx),%eax
80103835:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103838:	89 41 04             	mov    %eax,0x4(%ecx)
  *np->tf = *curproc->tf;
8010383b:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
8010383e:	89 c8                	mov    %ecx,%eax
80103840:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103843:	b9 13 00 00 00       	mov    $0x13,%ecx
80103848:	8b 73 1c             	mov    0x1c(%ebx),%esi
8010384b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
8010384d:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010384f:	8b 40 1c             	mov    0x1c(%eax),%eax
80103852:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103860:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103864:	85 c0                	test   %eax,%eax
80103866:	74 13                	je     8010387b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	50                   	push   %eax
8010386c:	e8 ff d5 ff ff       	call   80100e70 <filedup>
80103871:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103874:	83 c4 10             	add    $0x10,%esp
80103877:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010387b:	83 c6 01             	add    $0x1,%esi
8010387e:	83 fe 10             	cmp    $0x10,%esi
80103881:	75 dd                	jne    80103860 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103883:	83 ec 0c             	sub    $0xc,%esp
80103886:	ff 73 6c             	pushl  0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103889:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
8010388c:	e8 9f de ff ff       	call   80101730 <idup>
80103891:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103894:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103897:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010389a:	8d 47 70             	lea    0x70(%edi),%eax
8010389d:	6a 10                	push   $0x10
8010389f:	53                   	push   %ebx
801038a0:	50                   	push   %eax
801038a1:	e8 2a 0c 00 00       	call   801044d0 <safestrcpy>
  pid = np->pid;
801038a6:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
801038a9:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
801038b0:	e8 4b 09 00 00       	call   80104200 <acquire>
  np->state = RUNNABLE;
801038b5:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
801038bc:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
801038c3:	e8 f8 09 00 00       	call   801042c0 <release>
  return pid;
801038c8:	83 c4 10             	add    $0x10,%esp
}
801038cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038ce:	89 d8                	mov    %ebx,%eax
801038d0:	5b                   	pop    %ebx
801038d1:	5e                   	pop    %esi
801038d2:	5f                   	pop    %edi
801038d3:	5d                   	pop    %ebp
801038d4:	c3                   	ret    
    return -1;
801038d5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801038da:	eb ef                	jmp    801038cb <fork+0xdb>
    kfree(np->kstack);
801038dc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801038df:	83 ec 0c             	sub    $0xc,%esp
801038e2:	ff 73 0c             	pushl  0xc(%ebx)
801038e5:	e8 76 e8 ff ff       	call   80102160 <kfree>
    np->kstack = 0;
801038ea:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801038f1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801038f4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
801038fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103900:	eb c9                	jmp    801038cb <fork+0xdb>
80103902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103910 <scheduler>:
{
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	57                   	push   %edi
80103918:	56                   	push   %esi
80103919:	53                   	push   %ebx
8010391a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010391d:	e8 9e fc ff ff       	call   801035c0 <mycpu>
  c->proc = 0;
80103922:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103929:	00 00 00 
  struct cpu *c = mycpu();
8010392c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010392e:	8d 78 04             	lea    0x4(%eax),%edi
80103931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103938:	fb                   	sti    
    acquire(&ptable.lock);
80103939:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010393c:	bb 14 fd 18 80       	mov    $0x8018fd14,%ebx
    acquire(&ptable.lock);
80103941:	68 e0 fc 18 80       	push   $0x8018fce0
80103946:	e8 b5 08 00 00       	call   80104200 <acquire>
8010394b:	83 c4 10             	add    $0x10,%esp
8010394e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103950:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103954:	75 33                	jne    80103989 <scheduler+0x79>
      switchuvm(p);
80103956:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103959:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010395f:	53                   	push   %ebx
80103960:	e8 8b 2d 00 00       	call   801066f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103965:	58                   	pop    %eax
80103966:	5a                   	pop    %edx
80103967:	ff 73 20             	pushl  0x20(%ebx)
8010396a:	57                   	push   %edi
      p->state = RUNNING;
8010396b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103972:	e8 bc 0b 00 00       	call   80104533 <swtch>
      switchkvm();
80103977:	e8 54 2d 00 00       	call   801066d0 <switchkvm>
      c->proc = 0;
8010397c:	83 c4 10             	add    $0x10,%esp
8010397f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103986:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103989:	83 eb 80             	sub    $0xffffff80,%ebx
8010398c:	81 fb 14 1d 19 80    	cmp    $0x80191d14,%ebx
80103992:	75 bc                	jne    80103950 <scheduler+0x40>
    release(&ptable.lock);
80103994:	83 ec 0c             	sub    $0xc,%esp
80103997:	68 e0 fc 18 80       	push   $0x8018fce0
8010399c:	e8 1f 09 00 00       	call   801042c0 <release>
    sti();
801039a1:	83 c4 10             	add    $0x10,%esp
801039a4:	eb 92                	jmp    80103938 <scheduler+0x28>
801039a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ad:	8d 76 00             	lea    0x0(%esi),%esi

801039b0 <sched>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	56                   	push   %esi
801039b8:	53                   	push   %ebx
  struct proc *p = myproc();
801039b9:	e8 92 fc ff ff       	call   80103650 <myproc>
  if(!holding(&ptable.lock))
801039be:	83 ec 0c             	sub    $0xc,%esp
801039c1:	68 e0 fc 18 80       	push   $0x8018fce0
  struct proc *p = myproc();
801039c6:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
801039c8:	e8 e3 07 00 00       	call   801041b0 <holding>
801039cd:	83 c4 10             	add    $0x10,%esp
801039d0:	85 c0                	test   %eax,%eax
801039d2:	74 4f                	je     80103a23 <sched+0x73>
  if(mycpu()->ncli != 1)
801039d4:	e8 e7 fb ff ff       	call   801035c0 <mycpu>
801039d9:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801039e0:	75 68                	jne    80103a4a <sched+0x9a>
  if(p->state == RUNNING)
801039e2:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
801039e6:	74 55                	je     80103a3d <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039e8:	9c                   	pushf  
801039e9:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039ea:	f6 c4 02             	test   $0x2,%ah
801039ed:	75 41                	jne    80103a30 <sched+0x80>
  intena = mycpu()->intena;
801039ef:	e8 cc fb ff ff       	call   801035c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801039f4:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
801039f7:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801039fd:	e8 be fb ff ff       	call   801035c0 <mycpu>
80103a02:	83 ec 08             	sub    $0x8,%esp
80103a05:	ff 70 04             	pushl  0x4(%eax)
80103a08:	53                   	push   %ebx
80103a09:	e8 25 0b 00 00       	call   80104533 <swtch>
  mycpu()->intena = intena;
80103a0e:	e8 ad fb ff ff       	call   801035c0 <mycpu>
}
80103a13:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103a16:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a1f:	5b                   	pop    %ebx
80103a20:	5e                   	pop    %esi
80103a21:	5d                   	pop    %ebp
80103a22:	c3                   	ret    
    panic("sched ptable.lock");
80103a23:	83 ec 0c             	sub    $0xc,%esp
80103a26:	68 db 73 10 80       	push   $0x801073db
80103a2b:	e8 60 c9 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	68 07 74 10 80       	push   $0x80107407
80103a38:	e8 53 c9 ff ff       	call   80100390 <panic>
    panic("sched running");
80103a3d:	83 ec 0c             	sub    $0xc,%esp
80103a40:	68 f9 73 10 80       	push   $0x801073f9
80103a45:	e8 46 c9 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103a4a:	83 ec 0c             	sub    $0xc,%esp
80103a4d:	68 ed 73 10 80       	push   $0x801073ed
80103a52:	e8 39 c9 ff ff       	call   80100390 <panic>
80103a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <exit>:
{
80103a60:	f3 0f 1e fb          	endbr32 
80103a64:	55                   	push   %ebp
80103a65:	89 e5                	mov    %esp,%ebp
80103a67:	57                   	push   %edi
80103a68:	56                   	push   %esi
80103a69:	53                   	push   %ebx
80103a6a:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103a6d:	e8 de fb ff ff       	call   80103650 <myproc>
  if(curproc == initproc)
80103a72:	39 05 60 75 18 80    	cmp    %eax,0x80187560
80103a78:	0f 84 f9 00 00 00    	je     80103b77 <exit+0x117>
80103a7e:	89 c3                	mov    %eax,%ebx
80103a80:	8d 70 2c             	lea    0x2c(%eax),%esi
80103a83:	8d 78 6c             	lea    0x6c(%eax),%edi
80103a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103a90:	8b 06                	mov    (%esi),%eax
80103a92:	85 c0                	test   %eax,%eax
80103a94:	74 12                	je     80103aa8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	50                   	push   %eax
80103a9a:	e8 21 d4 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103a9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103aa5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103aa8:	83 c6 04             	add    $0x4,%esi
80103aab:	39 f7                	cmp    %esi,%edi
80103aad:	75 e1                	jne    80103a90 <exit+0x30>
  begin_op();
80103aaf:	e8 6c ef ff ff       	call   80102a20 <begin_op>
  iput(curproc->cwd);
80103ab4:	83 ec 0c             	sub    $0xc,%esp
80103ab7:	ff 73 6c             	pushl  0x6c(%ebx)
80103aba:	e8 d1 dd ff ff       	call   80101890 <iput>
  end_op();
80103abf:	e8 cc ef ff ff       	call   80102a90 <end_op>
  curproc->cwd = 0;
80103ac4:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80103acb:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
80103ad2:	e8 29 07 00 00       	call   80104200 <acquire>
  wakeup1(curproc->parent);
80103ad7:	8b 53 18             	mov    0x18(%ebx),%edx
80103ada:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103add:	b8 14 fd 18 80       	mov    $0x8018fd14,%eax
80103ae2:	eb 0e                	jmp    80103af2 <exit+0x92>
80103ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ae8:	83 e8 80             	sub    $0xffffff80,%eax
80103aeb:	3d 14 1d 19 80       	cmp    $0x80191d14,%eax
80103af0:	74 1c                	je     80103b0e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103af2:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103af6:	75 f0                	jne    80103ae8 <exit+0x88>
80103af8:	3b 50 24             	cmp    0x24(%eax),%edx
80103afb:	75 eb                	jne    80103ae8 <exit+0x88>
      p->state = RUNNABLE;
80103afd:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b04:	83 e8 80             	sub    $0xffffff80,%eax
80103b07:	3d 14 1d 19 80       	cmp    $0x80191d14,%eax
80103b0c:	75 e4                	jne    80103af2 <exit+0x92>
      p->parent = initproc;
80103b0e:	8b 0d 60 75 18 80    	mov    0x80187560,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b14:	ba 14 fd 18 80       	mov    $0x8018fd14,%edx
80103b19:	eb 10                	jmp    80103b2b <exit+0xcb>
80103b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop
80103b20:	83 ea 80             	sub    $0xffffff80,%edx
80103b23:	81 fa 14 1d 19 80    	cmp    $0x80191d14,%edx
80103b29:	74 33                	je     80103b5e <exit+0xfe>
    if(p->parent == curproc){
80103b2b:	39 5a 18             	cmp    %ebx,0x18(%edx)
80103b2e:	75 f0                	jne    80103b20 <exit+0xc0>
      if(p->state == ZOMBIE)
80103b30:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
80103b34:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
80103b37:	75 e7                	jne    80103b20 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b39:	b8 14 fd 18 80       	mov    $0x8018fd14,%eax
80103b3e:	eb 0a                	jmp    80103b4a <exit+0xea>
80103b40:	83 e8 80             	sub    $0xffffff80,%eax
80103b43:	3d 14 1d 19 80       	cmp    $0x80191d14,%eax
80103b48:	74 d6                	je     80103b20 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103b4a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103b4e:	75 f0                	jne    80103b40 <exit+0xe0>
80103b50:	3b 48 24             	cmp    0x24(%eax),%ecx
80103b53:	75 eb                	jne    80103b40 <exit+0xe0>
      p->state = RUNNABLE;
80103b55:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80103b5c:	eb e2                	jmp    80103b40 <exit+0xe0>
  curproc->state = ZOMBIE;
80103b5e:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80103b65:	e8 46 fe ff ff       	call   801039b0 <sched>
  panic("zombie exit");
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	68 28 74 10 80       	push   $0x80107428
80103b72:	e8 19 c8 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103b77:	83 ec 0c             	sub    $0xc,%esp
80103b7a:	68 1b 74 10 80       	push   $0x8010741b
80103b7f:	e8 0c c8 ff ff       	call   80100390 <panic>
80103b84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <yield>:
{
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103b9a:	68 e0 fc 18 80       	push   $0x8018fce0
80103b9f:	e8 5c 06 00 00       	call   80104200 <acquire>
  myproc()->state = RUNNABLE;
80103ba4:	e8 a7 fa ff ff       	call   80103650 <myproc>
80103ba9:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  sched();
80103bb0:	e8 fb fd ff ff       	call   801039b0 <sched>
  release(&ptable.lock);
80103bb5:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
80103bbc:	e8 ff 06 00 00       	call   801042c0 <release>
}
80103bc1:	83 c4 10             	add    $0x10,%esp
80103bc4:	c9                   	leave  
80103bc5:	c3                   	ret    
80103bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi

80103bd0 <sleep>:
{
80103bd0:	f3 0f 1e fb          	endbr32 
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	57                   	push   %edi
80103bd8:	56                   	push   %esi
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	8b 7d 08             	mov    0x8(%ebp),%edi
80103be0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103be3:	e8 68 fa ff ff       	call   80103650 <myproc>
  if(p == 0)
80103be8:	85 c0                	test   %eax,%eax
80103bea:	0f 84 8b 00 00 00    	je     80103c7b <sleep+0xab>
  if(lk == 0)
80103bf0:	85 f6                	test   %esi,%esi
80103bf2:	74 7a                	je     80103c6e <sleep+0x9e>
80103bf4:	89 c3                	mov    %eax,%ebx
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103bf6:	81 fe e0 fc 18 80    	cmp    $0x8018fce0,%esi
80103bfc:	74 52                	je     80103c50 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103bfe:	83 ec 0c             	sub    $0xc,%esp
80103c01:	68 e0 fc 18 80       	push   $0x8018fce0
80103c06:	e8 f5 05 00 00       	call   80104200 <acquire>
    release(lk);
80103c0b:	89 34 24             	mov    %esi,(%esp)
80103c0e:	e8 ad 06 00 00       	call   801042c0 <release>
  p->chan = chan;
80103c13:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103c16:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80103c1d:	e8 8e fd ff ff       	call   801039b0 <sched>
  p->chan = 0;
80103c22:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80103c29:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
80103c30:	e8 8b 06 00 00       	call   801042c0 <release>
    acquire(lk);
80103c35:	89 75 08             	mov    %esi,0x8(%ebp)
80103c38:	83 c4 10             	add    $0x10,%esp
}
80103c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3e:	5b                   	pop    %ebx
80103c3f:	5e                   	pop    %esi
80103c40:	5f                   	pop    %edi
80103c41:	5d                   	pop    %ebp
    acquire(lk);
80103c42:	e9 b9 05 00 00       	jmp    80104200 <acquire>
80103c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4e:	66 90                	xchg   %ax,%ax
  p->chan = chan;
80103c50:	89 78 24             	mov    %edi,0x24(%eax)
  p->state = SLEEPING;
80103c53:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)
  sched();
80103c5a:	e8 51 fd ff ff       	call   801039b0 <sched>
  p->chan = 0;
80103c5f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80103c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c69:	5b                   	pop    %ebx
80103c6a:	5e                   	pop    %esi
80103c6b:	5f                   	pop    %edi
80103c6c:	5d                   	pop    %ebp
80103c6d:	c3                   	ret    
    panic("sleep without lk");
80103c6e:	83 ec 0c             	sub    $0xc,%esp
80103c71:	68 3a 74 10 80       	push   $0x8010743a
80103c76:	e8 15 c7 ff ff       	call   80100390 <panic>
    panic("sleep");
80103c7b:	83 ec 0c             	sub    $0xc,%esp
80103c7e:	68 34 74 10 80       	push   $0x80107434
80103c83:	e8 08 c7 ff ff       	call   80100390 <panic>
80103c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop

80103c90 <wait>:
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	56                   	push   %esi
80103c98:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103c99:	e8 b2 f9 ff ff       	call   80103650 <myproc>
  acquire(&ptable.lock);
80103c9e:	83 ec 0c             	sub    $0xc,%esp
80103ca1:	68 e0 fc 18 80       	push   $0x8018fce0
  struct proc *curproc = myproc();
80103ca6:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103ca8:	e8 53 05 00 00       	call   80104200 <acquire>
80103cad:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103cb0:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb2:	bb 14 fd 18 80       	mov    $0x8018fd14,%ebx
80103cb7:	eb 12                	jmp    80103ccb <wait+0x3b>
80103cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cc0:	83 eb 80             	sub    $0xffffff80,%ebx
80103cc3:	81 fb 14 1d 19 80    	cmp    $0x80191d14,%ebx
80103cc9:	74 1b                	je     80103ce6 <wait+0x56>
      if(p->parent != curproc)
80103ccb:	39 73 18             	cmp    %esi,0x18(%ebx)
80103cce:	75 f0                	jne    80103cc0 <wait+0x30>
      if(p->state == ZOMBIE){
80103cd0:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80103cd4:	74 32                	je     80103d08 <wait+0x78>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd6:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103cd9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cde:	81 fb 14 1d 19 80    	cmp    $0x80191d14,%ebx
80103ce4:	75 e5                	jne    80103ccb <wait+0x3b>
    if(!havekids || curproc->killed){
80103ce6:	85 c0                	test   %eax,%eax
80103ce8:	74 74                	je     80103d5e <wait+0xce>
80103cea:	8b 46 28             	mov    0x28(%esi),%eax
80103ced:	85 c0                	test   %eax,%eax
80103cef:	75 6d                	jne    80103d5e <wait+0xce>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103cf1:	83 ec 08             	sub    $0x8,%esp
80103cf4:	68 e0 fc 18 80       	push   $0x8018fce0
80103cf9:	56                   	push   %esi
80103cfa:	e8 d1 fe ff ff       	call   80103bd0 <sleep>
    havekids = 0;
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	eb ac                	jmp    80103cb0 <wait+0x20>
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	ff 73 0c             	pushl  0xc(%ebx)
        pid = p->pid;
80103d0e:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80103d11:	e8 4a e4 ff ff       	call   80102160 <kfree>
        freevm(p->pgdir);
80103d16:	5a                   	pop    %edx
80103d17:	ff 73 08             	pushl  0x8(%ebx)
        p->kstack = 0;
80103d1a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80103d21:	e8 8a 2d 00 00       	call   80106ab0 <freevm>
        release(&ptable.lock);
80103d26:	c7 04 24 e0 fc 18 80 	movl   $0x8018fce0,(%esp)
        p->pid = 0;
80103d2d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80103d34:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80103d3b:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80103d3f:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80103d46:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
80103d4d:	e8 6e 05 00 00       	call   801042c0 <release>
        return pid;
80103d52:	83 c4 10             	add    $0x10,%esp
}
80103d55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d58:	89 f0                	mov    %esi,%eax
80103d5a:	5b                   	pop    %ebx
80103d5b:	5e                   	pop    %esi
80103d5c:	5d                   	pop    %ebp
80103d5d:	c3                   	ret    
      release(&ptable.lock);
80103d5e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d61:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103d66:	68 e0 fc 18 80       	push   $0x8018fce0
80103d6b:	e8 50 05 00 00       	call   801042c0 <release>
      return -1;
80103d70:	83 c4 10             	add    $0x10,%esp
80103d73:	eb e0                	jmp    80103d55 <wait+0xc5>
80103d75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103d80:	f3 0f 1e fb          	endbr32 
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	53                   	push   %ebx
80103d88:	83 ec 10             	sub    $0x10,%esp
80103d8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103d8e:	68 e0 fc 18 80       	push   $0x8018fce0
80103d93:	e8 68 04 00 00       	call   80104200 <acquire>
80103d98:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d9b:	b8 14 fd 18 80       	mov    $0x8018fd14,%eax
80103da0:	eb 10                	jmp    80103db2 <wakeup+0x32>
80103da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103da8:	83 e8 80             	sub    $0xffffff80,%eax
80103dab:	3d 14 1d 19 80       	cmp    $0x80191d14,%eax
80103db0:	74 1c                	je     80103dce <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80103db2:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103db6:	75 f0                	jne    80103da8 <wakeup+0x28>
80103db8:	3b 58 24             	cmp    0x24(%eax),%ebx
80103dbb:	75 eb                	jne    80103da8 <wakeup+0x28>
      p->state = RUNNABLE;
80103dbd:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc4:	83 e8 80             	sub    $0xffffff80,%eax
80103dc7:	3d 14 1d 19 80       	cmp    $0x80191d14,%eax
80103dcc:	75 e4                	jne    80103db2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
80103dce:	c7 45 08 e0 fc 18 80 	movl   $0x8018fce0,0x8(%ebp)
}
80103dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dd8:	c9                   	leave  
  release(&ptable.lock);
80103dd9:	e9 e2 04 00 00       	jmp    801042c0 <release>
80103dde:	66 90                	xchg   %ax,%ax

80103de0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
80103de5:	89 e5                	mov    %esp,%ebp
80103de7:	53                   	push   %ebx
80103de8:	83 ec 10             	sub    $0x10,%esp
80103deb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103dee:	68 e0 fc 18 80       	push   $0x8018fce0
80103df3:	e8 08 04 00 00       	call   80104200 <acquire>
80103df8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dfb:	b8 14 fd 18 80       	mov    $0x8018fd14,%eax
80103e00:	eb 10                	jmp    80103e12 <kill+0x32>
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e08:	83 e8 80             	sub    $0xffffff80,%eax
80103e0b:	3d 14 1d 19 80       	cmp    $0x80191d14,%eax
80103e10:	74 36                	je     80103e48 <kill+0x68>
    if(p->pid == pid){
80103e12:	39 58 14             	cmp    %ebx,0x14(%eax)
80103e15:	75 f1                	jne    80103e08 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e17:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80103e1b:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
80103e22:	75 07                	jne    80103e2b <kill+0x4b>
        p->state = RUNNABLE;
80103e24:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80103e2b:	83 ec 0c             	sub    $0xc,%esp
80103e2e:	68 e0 fc 18 80       	push   $0x8018fce0
80103e33:	e8 88 04 00 00       	call   801042c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80103e3b:	83 c4 10             	add    $0x10,%esp
80103e3e:	31 c0                	xor    %eax,%eax
}
80103e40:	c9                   	leave  
80103e41:	c3                   	ret    
80103e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	68 e0 fc 18 80       	push   $0x8018fce0
80103e50:	e8 6b 04 00 00       	call   801042c0 <release>
}
80103e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80103e58:	83 c4 10             	add    $0x10,%esp
80103e5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e60:	c9                   	leave  
80103e61:	c3                   	ret    
80103e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e70 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e70:	f3 0f 1e fb          	endbr32 
80103e74:	55                   	push   %ebp
80103e75:	89 e5                	mov    %esp,%ebp
80103e77:	57                   	push   %edi
80103e78:	56                   	push   %esi
80103e79:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e7c:	53                   	push   %ebx
80103e7d:	bb 84 fd 18 80       	mov    $0x8018fd84,%ebx
80103e82:	83 ec 3c             	sub    $0x3c,%esp
80103e85:	eb 28                	jmp    80103eaf <procdump+0x3f>
80103e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 bb 77 10 80       	push   $0x801077bb
80103e98:	e8 13 c8 ff ff       	call   801006b0 <cprintf>
80103e9d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea0:	83 eb 80             	sub    $0xffffff80,%ebx
80103ea3:	81 fb 84 1d 19 80    	cmp    $0x80191d84,%ebx
80103ea9:	0f 84 81 00 00 00    	je     80103f30 <procdump+0xc0>
    if(p->state == UNUSED)
80103eaf:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103eb2:	85 c0                	test   %eax,%eax
80103eb4:	74 ea                	je     80103ea0 <procdump+0x30>
      state = "???";
80103eb6:	ba 4b 74 10 80       	mov    $0x8010744b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ebb:	83 f8 05             	cmp    $0x5,%eax
80103ebe:	77 11                	ja     80103ed1 <procdump+0x61>
80103ec0:	8b 14 85 ac 74 10 80 	mov    -0x7fef8b54(,%eax,4),%edx
      state = "???";
80103ec7:	b8 4b 74 10 80       	mov    $0x8010744b,%eax
80103ecc:	85 d2                	test   %edx,%edx
80103ece:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ed1:	53                   	push   %ebx
80103ed2:	52                   	push   %edx
80103ed3:	ff 73 a4             	pushl  -0x5c(%ebx)
80103ed6:	68 4f 74 10 80       	push   $0x8010744f
80103edb:	e8 d0 c7 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80103ee0:	83 c4 10             	add    $0x10,%esp
80103ee3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ee7:	75 a7                	jne    80103e90 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ee9:	83 ec 08             	sub    $0x8,%esp
80103eec:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103eef:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ef2:	50                   	push   %eax
80103ef3:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ef6:	8b 40 0c             	mov    0xc(%eax),%eax
80103ef9:	83 c0 08             	add    $0x8,%eax
80103efc:	50                   	push   %eax
80103efd:	e8 9e 01 00 00       	call   801040a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f02:	83 c4 10             	add    $0x10,%esp
80103f05:	8d 76 00             	lea    0x0(%esi),%esi
80103f08:	8b 17                	mov    (%edi),%edx
80103f0a:	85 d2                	test   %edx,%edx
80103f0c:	74 82                	je     80103e90 <procdump+0x20>
        cprintf(" %p", pc[i]);
80103f0e:	83 ec 08             	sub    $0x8,%esp
80103f11:	83 c7 04             	add    $0x4,%edi
80103f14:	52                   	push   %edx
80103f15:	68 01 6f 10 80       	push   $0x80106f01
80103f1a:	e8 91 c7 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f1f:	83 c4 10             	add    $0x10,%esp
80103f22:	39 fe                	cmp    %edi,%esi
80103f24:	75 e2                	jne    80103f08 <procdump+0x98>
80103f26:	e9 65 ff ff ff       	jmp    80103e90 <procdump+0x20>
80103f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f2f:	90                   	nop
  }
}
80103f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f33:	5b                   	pop    %ebx
80103f34:	5e                   	pop    %esi
80103f35:	5f                   	pop    %edi
80103f36:	5d                   	pop    %ebp
80103f37:	c3                   	ret    
80103f38:	66 90                	xchg   %ax,%ax
80103f3a:	66 90                	xchg   %ax,%ax
80103f3c:	66 90                	xchg   %ax,%ax
80103f3e:	66 90                	xchg   %ax,%ax

80103f40 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	53                   	push   %ebx
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f4e:	68 c4 74 10 80       	push   $0x801074c4
80103f53:	8d 43 04             	lea    0x4(%ebx),%eax
80103f56:	50                   	push   %eax
80103f57:	e8 24 01 00 00       	call   80104080 <initlock>
  lk->name = name;
80103f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80103f65:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80103f68:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103f6f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103f72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f75:	c9                   	leave  
80103f76:	c3                   	ret    
80103f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7e:	66 90                	xchg   %ax,%ax

80103f80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f80:	f3 0f 1e fb          	endbr32 
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	56                   	push   %esi
80103f88:	53                   	push   %ebx
80103f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f8c:	8d 73 04             	lea    0x4(%ebx),%esi
80103f8f:	83 ec 0c             	sub    $0xc,%esp
80103f92:	56                   	push   %esi
80103f93:	e8 68 02 00 00       	call   80104200 <acquire>
  while (lk->locked) {
80103f98:	8b 13                	mov    (%ebx),%edx
80103f9a:	83 c4 10             	add    $0x10,%esp
80103f9d:	85 d2                	test   %edx,%edx
80103f9f:	74 1a                	je     80103fbb <acquiresleep+0x3b>
80103fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103fa8:	83 ec 08             	sub    $0x8,%esp
80103fab:	56                   	push   %esi
80103fac:	53                   	push   %ebx
80103fad:	e8 1e fc ff ff       	call   80103bd0 <sleep>
  while (lk->locked) {
80103fb2:	8b 03                	mov    (%ebx),%eax
80103fb4:	83 c4 10             	add    $0x10,%esp
80103fb7:	85 c0                	test   %eax,%eax
80103fb9:	75 ed                	jne    80103fa8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80103fbb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fc1:	e8 8a f6 ff ff       	call   80103650 <myproc>
80103fc6:	8b 40 14             	mov    0x14(%eax),%eax
80103fc9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fcc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5d                   	pop    %ebp
  release(&lk->lk);
80103fd5:	e9 e6 02 00 00       	jmp    801042c0 <release>
80103fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fe0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103fe0:	f3 0f 1e fb          	endbr32 
80103fe4:	55                   	push   %ebp
80103fe5:	89 e5                	mov    %esp,%ebp
80103fe7:	56                   	push   %esi
80103fe8:	53                   	push   %ebx
80103fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fec:	8d 73 04             	lea    0x4(%ebx),%esi
80103fef:	83 ec 0c             	sub    $0xc,%esp
80103ff2:	56                   	push   %esi
80103ff3:	e8 08 02 00 00       	call   80104200 <acquire>
  lk->locked = 0;
80103ff8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ffe:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104005:	89 1c 24             	mov    %ebx,(%esp)
80104008:	e8 73 fd ff ff       	call   80103d80 <wakeup>
  release(&lk->lk);
8010400d:	89 75 08             	mov    %esi,0x8(%ebp)
80104010:	83 c4 10             	add    $0x10,%esp
}
80104013:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104016:	5b                   	pop    %ebx
80104017:	5e                   	pop    %esi
80104018:	5d                   	pop    %ebp
  release(&lk->lk);
80104019:	e9 a2 02 00 00       	jmp    801042c0 <release>
8010401e:	66 90                	xchg   %ax,%ax

80104020 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	57                   	push   %edi
80104028:	31 ff                	xor    %edi,%edi
8010402a:	56                   	push   %esi
8010402b:	53                   	push   %ebx
8010402c:	83 ec 18             	sub    $0x18,%esp
8010402f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104032:	8d 73 04             	lea    0x4(%ebx),%esi
80104035:	56                   	push   %esi
80104036:	e8 c5 01 00 00       	call   80104200 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010403b:	8b 03                	mov    (%ebx),%eax
8010403d:	83 c4 10             	add    $0x10,%esp
80104040:	85 c0                	test   %eax,%eax
80104042:	75 1c                	jne    80104060 <holdingsleep+0x40>
  release(&lk->lk);
80104044:	83 ec 0c             	sub    $0xc,%esp
80104047:	56                   	push   %esi
80104048:	e8 73 02 00 00       	call   801042c0 <release>
  return r;
}
8010404d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104050:	89 f8                	mov    %edi,%eax
80104052:	5b                   	pop    %ebx
80104053:	5e                   	pop    %esi
80104054:	5f                   	pop    %edi
80104055:	5d                   	pop    %ebp
80104056:	c3                   	ret    
80104057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104060:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104063:	e8 e8 f5 ff ff       	call   80103650 <myproc>
80104068:	39 58 14             	cmp    %ebx,0x14(%eax)
8010406b:	0f 94 c0             	sete   %al
8010406e:	0f b6 c0             	movzbl %al,%eax
80104071:	89 c7                	mov    %eax,%edi
80104073:	eb cf                	jmp    80104044 <holdingsleep+0x24>
80104075:	66 90                	xchg   %ax,%ax
80104077:	66 90                	xchg   %ax,%ax
80104079:	66 90                	xchg   %ax,%ax
8010407b:	66 90                	xchg   %ax,%ax
8010407d:	66 90                	xchg   %ax,%ax
8010407f:	90                   	nop

80104080 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104080:	f3 0f 1e fb          	endbr32 
80104084:	55                   	push   %ebp
80104085:	89 e5                	mov    %esp,%ebp
80104087:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010408a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010408d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104093:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104096:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010409d:	5d                   	pop    %ebp
8010409e:	c3                   	ret    
8010409f:	90                   	nop

801040a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801040a5:	31 d2                	xor    %edx,%edx
{
801040a7:	89 e5                	mov    %esp,%ebp
801040a9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
{
801040ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801040b0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801040b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040b7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040b8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801040be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040c4:	77 1a                	ja     801040e0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040c6:	8b 58 04             	mov    0x4(%eax),%ebx
801040c9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801040cc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801040cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801040d1:	83 fa 0a             	cmp    $0xa,%edx
801040d4:	75 e2                	jne    801040b8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040d6:	5b                   	pop    %ebx
801040d7:	5d                   	pop    %ebp
801040d8:	c3                   	ret    
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801040e0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801040e3:	8d 51 28             	lea    0x28(%ecx),%edx
801040e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ed:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801040f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801040f6:	83 c0 04             	add    $0x4,%eax
801040f9:	39 d0                	cmp    %edx,%eax
801040fb:	75 f3                	jne    801040f0 <getcallerpcs+0x50>
}
801040fd:	5b                   	pop    %ebx
801040fe:	5d                   	pop    %ebp
801040ff:	c3                   	ret    

80104100 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 04             	sub    $0x4,%esp
8010410b:	9c                   	pushf  
8010410c:	5b                   	pop    %ebx
  asm volatile("cli");
8010410d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010410e:	e8 ad f4 ff ff       	call   801035c0 <mycpu>
80104113:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104119:	85 c0                	test   %eax,%eax
8010411b:	74 13                	je     80104130 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010411d:	e8 9e f4 ff ff       	call   801035c0 <mycpu>
80104122:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104129:	83 c4 04             	add    $0x4,%esp
8010412c:	5b                   	pop    %ebx
8010412d:	5d                   	pop    %ebp
8010412e:	c3                   	ret    
8010412f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104130:	e8 8b f4 ff ff       	call   801035c0 <mycpu>
80104135:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010413b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104141:	eb da                	jmp    8010411d <pushcli+0x1d>
80104143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <popcli>:

void
popcli(void)
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010415a:	9c                   	pushf  
8010415b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010415c:	f6 c4 02             	test   $0x2,%ah
8010415f:	75 31                	jne    80104192 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104161:	e8 5a f4 ff ff       	call   801035c0 <mycpu>
80104166:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010416d:	78 30                	js     8010419f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010416f:	e8 4c f4 ff ff       	call   801035c0 <mycpu>
80104174:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010417a:	85 d2                	test   %edx,%edx
8010417c:	74 02                	je     80104180 <popcli+0x30>
    sti();
}
8010417e:	c9                   	leave  
8010417f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104180:	e8 3b f4 ff ff       	call   801035c0 <mycpu>
80104185:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010418b:	85 c0                	test   %eax,%eax
8010418d:	74 ef                	je     8010417e <popcli+0x2e>
  asm volatile("sti");
8010418f:	fb                   	sti    
}
80104190:	c9                   	leave  
80104191:	c3                   	ret    
    panic("popcli - interruptible");
80104192:	83 ec 0c             	sub    $0xc,%esp
80104195:	68 cf 74 10 80       	push   $0x801074cf
8010419a:	e8 f1 c1 ff ff       	call   80100390 <panic>
    panic("popcli");
8010419f:	83 ec 0c             	sub    $0xc,%esp
801041a2:	68 e6 74 10 80       	push   $0x801074e6
801041a7:	e8 e4 c1 ff ff       	call   80100390 <panic>
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041b0 <holding>:
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
801041b9:	8b 75 08             	mov    0x8(%ebp),%esi
801041bc:	31 db                	xor    %ebx,%ebx
  pushcli();
801041be:	e8 3d ff ff ff       	call   80104100 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801041c3:	8b 06                	mov    (%esi),%eax
801041c5:	85 c0                	test   %eax,%eax
801041c7:	75 0f                	jne    801041d8 <holding+0x28>
  popcli();
801041c9:	e8 82 ff ff ff       	call   80104150 <popcli>
}
801041ce:	89 d8                	mov    %ebx,%eax
801041d0:	5b                   	pop    %ebx
801041d1:	5e                   	pop    %esi
801041d2:	5d                   	pop    %ebp
801041d3:	c3                   	ret    
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801041d8:	8b 5e 08             	mov    0x8(%esi),%ebx
801041db:	e8 e0 f3 ff ff       	call   801035c0 <mycpu>
801041e0:	39 c3                	cmp    %eax,%ebx
801041e2:	0f 94 c3             	sete   %bl
  popcli();
801041e5:	e8 66 ff ff ff       	call   80104150 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801041ea:	0f b6 db             	movzbl %bl,%ebx
}
801041ed:	89 d8                	mov    %ebx,%eax
801041ef:	5b                   	pop    %ebx
801041f0:	5e                   	pop    %esi
801041f1:	5d                   	pop    %ebp
801041f2:	c3                   	ret    
801041f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <acquire>:
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	56                   	push   %esi
80104208:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104209:	e8 f2 fe ff ff       	call   80104100 <pushcli>
  if(holding(lk))
8010420e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104211:	83 ec 0c             	sub    $0xc,%esp
80104214:	53                   	push   %ebx
80104215:	e8 96 ff ff ff       	call   801041b0 <holding>
8010421a:	83 c4 10             	add    $0x10,%esp
8010421d:	85 c0                	test   %eax,%eax
8010421f:	0f 85 7f 00 00 00    	jne    801042a4 <acquire+0xa4>
80104225:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104227:	ba 01 00 00 00       	mov    $0x1,%edx
8010422c:	eb 05                	jmp    80104233 <acquire+0x33>
8010422e:	66 90                	xchg   %ax,%ax
80104230:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104233:	89 d0                	mov    %edx,%eax
80104235:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104238:	85 c0                	test   %eax,%eax
8010423a:	75 f4                	jne    80104230 <acquire+0x30>
  __sync_synchronize();
8010423c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104241:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104244:	e8 77 f3 ff ff       	call   801035c0 <mycpu>
80104249:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010424c:	89 e8                	mov    %ebp,%eax
8010424e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104250:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104256:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010425c:	77 22                	ja     80104280 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010425e:	8b 50 04             	mov    0x4(%eax),%edx
80104261:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104265:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104268:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010426a:	83 fe 0a             	cmp    $0xa,%esi
8010426d:	75 e1                	jne    80104250 <acquire+0x50>
}
8010426f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104272:	5b                   	pop    %ebx
80104273:	5e                   	pop    %esi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret    
80104276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104280:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104284:	83 c3 34             	add    $0x34,%ebx
80104287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104296:	83 c0 04             	add    $0x4,%eax
80104299:	39 d8                	cmp    %ebx,%eax
8010429b:	75 f3                	jne    80104290 <acquire+0x90>
}
8010429d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042a0:	5b                   	pop    %ebx
801042a1:	5e                   	pop    %esi
801042a2:	5d                   	pop    %ebp
801042a3:	c3                   	ret    
    panic("acquire");
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	68 ed 74 10 80       	push   $0x801074ed
801042ac:	e8 df c0 ff ff       	call   80100390 <panic>
801042b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bf:	90                   	nop

801042c0 <release>:
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	53                   	push   %ebx
801042c8:	83 ec 10             	sub    $0x10,%esp
801042cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801042ce:	53                   	push   %ebx
801042cf:	e8 dc fe ff ff       	call   801041b0 <holding>
801042d4:	83 c4 10             	add    $0x10,%esp
801042d7:	85 c0                	test   %eax,%eax
801042d9:	74 22                	je     801042fd <release+0x3d>
  lk->pcs[0] = 0;
801042db:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801042e9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801042ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801042f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f7:	c9                   	leave  
  popcli();
801042f8:	e9 53 fe ff ff       	jmp    80104150 <popcli>
    panic("release");
801042fd:	83 ec 0c             	sub    $0xc,%esp
80104300:	68 f5 74 10 80       	push   $0x801074f5
80104305:	e8 86 c0 ff ff       	call   80100390 <panic>
8010430a:	66 90                	xchg   %ax,%ax
8010430c:	66 90                	xchg   %ax,%ax
8010430e:	66 90                	xchg   %ax,%ax

80104310 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	57                   	push   %edi
80104318:	8b 55 08             	mov    0x8(%ebp),%edx
8010431b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010431e:	53                   	push   %ebx
8010431f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104322:	89 d7                	mov    %edx,%edi
80104324:	09 cf                	or     %ecx,%edi
80104326:	83 e7 03             	and    $0x3,%edi
80104329:	75 25                	jne    80104350 <memset+0x40>
    c &= 0xFF;
8010432b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010432e:	c1 e0 18             	shl    $0x18,%eax
80104331:	89 fb                	mov    %edi,%ebx
80104333:	c1 e9 02             	shr    $0x2,%ecx
80104336:	c1 e3 10             	shl    $0x10,%ebx
80104339:	09 d8                	or     %ebx,%eax
8010433b:	09 f8                	or     %edi,%eax
8010433d:	c1 e7 08             	shl    $0x8,%edi
80104340:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104342:	89 d7                	mov    %edx,%edi
80104344:	fc                   	cld    
80104345:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104347:	5b                   	pop    %ebx
80104348:	89 d0                	mov    %edx,%eax
8010434a:	5f                   	pop    %edi
8010434b:	5d                   	pop    %ebp
8010434c:	c3                   	ret    
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104350:	89 d7                	mov    %edx,%edi
80104352:	fc                   	cld    
80104353:	f3 aa                	rep stos %al,%es:(%edi)
80104355:	5b                   	pop    %ebx
80104356:	89 d0                	mov    %edx,%eax
80104358:	5f                   	pop    %edi
80104359:	5d                   	pop    %ebp
8010435a:	c3                   	ret    
8010435b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010435f:	90                   	nop

80104360 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104360:	f3 0f 1e fb          	endbr32 
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	56                   	push   %esi
80104368:	8b 75 10             	mov    0x10(%ebp),%esi
8010436b:	8b 55 08             	mov    0x8(%ebp),%edx
8010436e:	53                   	push   %ebx
8010436f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104372:	85 f6                	test   %esi,%esi
80104374:	74 2a                	je     801043a0 <memcmp+0x40>
80104376:	01 c6                	add    %eax,%esi
80104378:	eb 10                	jmp    8010438a <memcmp+0x2a>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104380:	83 c0 01             	add    $0x1,%eax
80104383:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104386:	39 f0                	cmp    %esi,%eax
80104388:	74 16                	je     801043a0 <memcmp+0x40>
    if(*s1 != *s2)
8010438a:	0f b6 0a             	movzbl (%edx),%ecx
8010438d:	0f b6 18             	movzbl (%eax),%ebx
80104390:	38 d9                	cmp    %bl,%cl
80104392:	74 ec                	je     80104380 <memcmp+0x20>
      return *s1 - *s2;
80104394:	0f b6 c1             	movzbl %cl,%eax
80104397:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104399:	5b                   	pop    %ebx
8010439a:	5e                   	pop    %esi
8010439b:	5d                   	pop    %ebp
8010439c:	c3                   	ret    
8010439d:	8d 76 00             	lea    0x0(%esi),%esi
801043a0:	5b                   	pop    %ebx
  return 0;
801043a1:	31 c0                	xor    %eax,%eax
}
801043a3:	5e                   	pop    %esi
801043a4:	5d                   	pop    %ebp
801043a5:	c3                   	ret    
801043a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	57                   	push   %edi
801043b8:	8b 55 08             	mov    0x8(%ebp),%edx
801043bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801043be:	56                   	push   %esi
801043bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801043c2:	39 d6                	cmp    %edx,%esi
801043c4:	73 2a                	jae    801043f0 <memmove+0x40>
801043c6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801043c9:	39 fa                	cmp    %edi,%edx
801043cb:	73 23                	jae    801043f0 <memmove+0x40>
801043cd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801043d0:	85 c9                	test   %ecx,%ecx
801043d2:	74 13                	je     801043e7 <memmove+0x37>
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801043d8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801043dc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801043df:	83 e8 01             	sub    $0x1,%eax
801043e2:	83 f8 ff             	cmp    $0xffffffff,%eax
801043e5:	75 f1                	jne    801043d8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043e7:	5e                   	pop    %esi
801043e8:	89 d0                	mov    %edx,%eax
801043ea:	5f                   	pop    %edi
801043eb:	5d                   	pop    %ebp
801043ec:	c3                   	ret    
801043ed:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801043f0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801043f3:	89 d7                	mov    %edx,%edi
801043f5:	85 c9                	test   %ecx,%ecx
801043f7:	74 ee                	je     801043e7 <memmove+0x37>
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104400:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104401:	39 f0                	cmp    %esi,%eax
80104403:	75 fb                	jne    80104400 <memmove+0x50>
}
80104405:	5e                   	pop    %esi
80104406:	89 d0                	mov    %edx,%eax
80104408:	5f                   	pop    %edi
80104409:	5d                   	pop    %ebp
8010440a:	c3                   	ret    
8010440b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop

80104410 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104410:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104414:	eb 9a                	jmp    801043b0 <memmove>
80104416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	56                   	push   %esi
80104428:	8b 75 10             	mov    0x10(%ebp),%esi
8010442b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010442e:	53                   	push   %ebx
8010442f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104432:	85 f6                	test   %esi,%esi
80104434:	74 32                	je     80104468 <strncmp+0x48>
80104436:	01 c6                	add    %eax,%esi
80104438:	eb 14                	jmp    8010444e <strncmp+0x2e>
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104440:	38 da                	cmp    %bl,%dl
80104442:	75 14                	jne    80104458 <strncmp+0x38>
    n--, p++, q++;
80104444:	83 c0 01             	add    $0x1,%eax
80104447:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010444a:	39 f0                	cmp    %esi,%eax
8010444c:	74 1a                	je     80104468 <strncmp+0x48>
8010444e:	0f b6 11             	movzbl (%ecx),%edx
80104451:	0f b6 18             	movzbl (%eax),%ebx
80104454:	84 d2                	test   %dl,%dl
80104456:	75 e8                	jne    80104440 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104458:	0f b6 c2             	movzbl %dl,%eax
8010445b:	29 d8                	sub    %ebx,%eax
}
8010445d:	5b                   	pop    %ebx
8010445e:	5e                   	pop    %esi
8010445f:	5d                   	pop    %ebp
80104460:	c3                   	ret    
80104461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104468:	5b                   	pop    %ebx
    return 0;
80104469:	31 c0                	xor    %eax,%eax
}
8010446b:	5e                   	pop    %esi
8010446c:	5d                   	pop    %ebp
8010446d:	c3                   	ret    
8010446e:	66 90                	xchg   %ax,%ax

80104470 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104470:	f3 0f 1e fb          	endbr32 
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	57                   	push   %edi
80104478:	56                   	push   %esi
80104479:	8b 75 08             	mov    0x8(%ebp),%esi
8010447c:	53                   	push   %ebx
8010447d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104480:	89 f2                	mov    %esi,%edx
80104482:	eb 1b                	jmp    8010449f <strncpy+0x2f>
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104488:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010448c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010448f:	83 c2 01             	add    $0x1,%edx
80104492:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104496:	89 f9                	mov    %edi,%ecx
80104498:	88 4a ff             	mov    %cl,-0x1(%edx)
8010449b:	84 c9                	test   %cl,%cl
8010449d:	74 09                	je     801044a8 <strncpy+0x38>
8010449f:	89 c3                	mov    %eax,%ebx
801044a1:	83 e8 01             	sub    $0x1,%eax
801044a4:	85 db                	test   %ebx,%ebx
801044a6:	7f e0                	jg     80104488 <strncpy+0x18>
    ;
  while(n-- > 0)
801044a8:	89 d1                	mov    %edx,%ecx
801044aa:	85 c0                	test   %eax,%eax
801044ac:	7e 15                	jle    801044c3 <strncpy+0x53>
801044ae:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801044b0:	83 c1 01             	add    $0x1,%ecx
801044b3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801044b7:	89 c8                	mov    %ecx,%eax
801044b9:	f7 d0                	not    %eax
801044bb:	01 d0                	add    %edx,%eax
801044bd:	01 d8                	add    %ebx,%eax
801044bf:	85 c0                	test   %eax,%eax
801044c1:	7f ed                	jg     801044b0 <strncpy+0x40>
  return os;
}
801044c3:	5b                   	pop    %ebx
801044c4:	89 f0                	mov    %esi,%eax
801044c6:	5e                   	pop    %esi
801044c7:	5f                   	pop    %edi
801044c8:	5d                   	pop    %ebp
801044c9:	c3                   	ret    
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	56                   	push   %esi
801044d8:	8b 55 10             	mov    0x10(%ebp),%edx
801044db:	8b 75 08             	mov    0x8(%ebp),%esi
801044de:	53                   	push   %ebx
801044df:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801044e2:	85 d2                	test   %edx,%edx
801044e4:	7e 21                	jle    80104507 <safestrcpy+0x37>
801044e6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801044ea:	89 f2                	mov    %esi,%edx
801044ec:	eb 12                	jmp    80104500 <safestrcpy+0x30>
801044ee:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044f0:	0f b6 08             	movzbl (%eax),%ecx
801044f3:	83 c0 01             	add    $0x1,%eax
801044f6:	83 c2 01             	add    $0x1,%edx
801044f9:	88 4a ff             	mov    %cl,-0x1(%edx)
801044fc:	84 c9                	test   %cl,%cl
801044fe:	74 04                	je     80104504 <safestrcpy+0x34>
80104500:	39 d8                	cmp    %ebx,%eax
80104502:	75 ec                	jne    801044f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104504:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104507:	89 f0                	mov    %esi,%eax
80104509:	5b                   	pop    %ebx
8010450a:	5e                   	pop    %esi
8010450b:	5d                   	pop    %ebp
8010450c:	c3                   	ret    
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <strlen>:

int
strlen(const char *s)
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104515:	31 c0                	xor    %eax,%eax
{
80104517:	89 e5                	mov    %esp,%ebp
80104519:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010451c:	80 3a 00             	cmpb   $0x0,(%edx)
8010451f:	74 10                	je     80104531 <strlen+0x21>
80104521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104528:	83 c0 01             	add    $0x1,%eax
8010452b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010452f:	75 f7                	jne    80104528 <strlen+0x18>
    ;
  return n;
}
80104531:	5d                   	pop    %ebp
80104532:	c3                   	ret    

80104533 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104533:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104537:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010453b:	55                   	push   %ebp
  pushl %ebx
8010453c:	53                   	push   %ebx
  pushl %esi
8010453d:	56                   	push   %esi
  pushl %edi
8010453e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010453f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104541:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104543:	5f                   	pop    %edi
  popl %esi
80104544:	5e                   	pop    %esi
  popl %ebx
80104545:	5b                   	pop    %ebx
  popl %ebp
80104546:	5d                   	pop    %ebp
  ret
80104547:	c3                   	ret    
80104548:	66 90                	xchg   %ax,%ax
8010454a:	66 90                	xchg   %ax,%ax
8010454c:	66 90                	xchg   %ax,%ax
8010454e:	66 90                	xchg   %ax,%ax

80104550 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104550:	f3 0f 1e fb          	endbr32 
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	53                   	push   %ebx
80104558:	83 ec 04             	sub    $0x4,%esp
8010455b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010455e:	e8 ed f0 ff ff       	call   80103650 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104563:	8b 40 04             	mov    0x4(%eax),%eax
80104566:	39 d8                	cmp    %ebx,%eax
80104568:	76 16                	jbe    80104580 <fetchint+0x30>
8010456a:	8d 53 04             	lea    0x4(%ebx),%edx
8010456d:	39 d0                	cmp    %edx,%eax
8010456f:	72 0f                	jb     80104580 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104571:	8b 45 0c             	mov    0xc(%ebp),%eax
80104574:	8b 13                	mov    (%ebx),%edx
80104576:	89 10                	mov    %edx,(%eax)
  return 0;
80104578:	31 c0                	xor    %eax,%eax
}
8010457a:	83 c4 04             	add    $0x4,%esp
8010457d:	5b                   	pop    %ebx
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret    
    return -1;
80104580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104585:	eb f3                	jmp    8010457a <fetchint+0x2a>
80104587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458e:	66 90                	xchg   %ax,%ax

80104590 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104590:	f3 0f 1e fb          	endbr32 
80104594:	55                   	push   %ebp
80104595:	89 e5                	mov    %esp,%ebp
80104597:	53                   	push   %ebx
80104598:	83 ec 04             	sub    $0x4,%esp
8010459b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010459e:	e8 ad f0 ff ff       	call   80103650 <myproc>

  if(addr >= curproc->sz)
801045a3:	39 58 04             	cmp    %ebx,0x4(%eax)
801045a6:	76 30                	jbe    801045d8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801045a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801045ab:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801045ad:	8b 50 04             	mov    0x4(%eax),%edx
  for(s = *pp; s < ep; s++){
801045b0:	39 d3                	cmp    %edx,%ebx
801045b2:	73 24                	jae    801045d8 <fetchstr+0x48>
801045b4:	89 d8                	mov    %ebx,%eax
801045b6:	eb 0f                	jmp    801045c7 <fetchstr+0x37>
801045b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop
801045c0:	83 c0 01             	add    $0x1,%eax
801045c3:	39 c2                	cmp    %eax,%edx
801045c5:	76 11                	jbe    801045d8 <fetchstr+0x48>
    if(*s == 0)
801045c7:	80 38 00             	cmpb   $0x0,(%eax)
801045ca:	75 f4                	jne    801045c0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801045cc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801045cf:	29 d8                	sub    %ebx,%eax
}
801045d1:	5b                   	pop    %ebx
801045d2:	5d                   	pop    %ebp
801045d3:	c3                   	ret    
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d8:	83 c4 04             	add    $0x4,%esp
    return -1;
801045db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045e0:	5b                   	pop    %ebx
801045e1:	5d                   	pop    %ebp
801045e2:	c3                   	ret    
801045e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801045f0:	f3 0f 1e fb          	endbr32 
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	56                   	push   %esi
801045f8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045f9:	e8 52 f0 ff ff       	call   80103650 <myproc>
801045fe:	8b 55 08             	mov    0x8(%ebp),%edx
80104601:	8b 40 1c             	mov    0x1c(%eax),%eax
80104604:	8b 40 44             	mov    0x44(%eax),%eax
80104607:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010460a:	e8 41 f0 ff ff       	call   80103650 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010460f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104612:	8b 40 04             	mov    0x4(%eax),%eax
80104615:	39 c6                	cmp    %eax,%esi
80104617:	73 17                	jae    80104630 <argint+0x40>
80104619:	8d 53 08             	lea    0x8(%ebx),%edx
8010461c:	39 d0                	cmp    %edx,%eax
8010461e:	72 10                	jb     80104630 <argint+0x40>
  *ip = *(int*)(addr);
80104620:	8b 45 0c             	mov    0xc(%ebp),%eax
80104623:	8b 53 04             	mov    0x4(%ebx),%edx
80104626:	89 10                	mov    %edx,(%eax)
  return 0;
80104628:	31 c0                	xor    %eax,%eax
}
8010462a:	5b                   	pop    %ebx
8010462b:	5e                   	pop    %esi
8010462c:	5d                   	pop    %ebp
8010462d:	c3                   	ret    
8010462e:	66 90                	xchg   %ax,%ax
    return -1;
80104630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104635:	eb f3                	jmp    8010462a <argint+0x3a>
80104637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463e:	66 90                	xchg   %ax,%ax

80104640 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	56                   	push   %esi
80104648:	53                   	push   %ebx
80104649:	83 ec 10             	sub    $0x10,%esp
8010464c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010464f:	e8 fc ef ff ff       	call   80103650 <myproc>
 
  if(argint(n, &i) < 0)
80104654:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104657:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104659:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010465c:	50                   	push   %eax
8010465d:	ff 75 08             	pushl  0x8(%ebp)
80104660:	e8 8b ff ff ff       	call   801045f0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104665:	83 c4 10             	add    $0x10,%esp
80104668:	85 c0                	test   %eax,%eax
8010466a:	78 24                	js     80104690 <argptr+0x50>
8010466c:	85 db                	test   %ebx,%ebx
8010466e:	78 20                	js     80104690 <argptr+0x50>
80104670:	8b 56 04             	mov    0x4(%esi),%edx
80104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104676:	39 c2                	cmp    %eax,%edx
80104678:	76 16                	jbe    80104690 <argptr+0x50>
8010467a:	01 c3                	add    %eax,%ebx
8010467c:	39 da                	cmp    %ebx,%edx
8010467e:	72 10                	jb     80104690 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104680:	8b 55 0c             	mov    0xc(%ebp),%edx
80104683:	89 02                	mov    %eax,(%edx)
  return 0;
80104685:	31 c0                	xor    %eax,%eax
}
80104687:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010468a:	5b                   	pop    %ebx
8010468b:	5e                   	pop    %esi
8010468c:	5d                   	pop    %ebp
8010468d:	c3                   	ret    
8010468e:	66 90                	xchg   %ax,%ax
    return -1;
80104690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104695:	eb f0                	jmp    80104687 <argptr+0x47>
80104697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469e:	66 90                	xchg   %ax,%ax

801046a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801046aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046ad:	50                   	push   %eax
801046ae:	ff 75 08             	pushl  0x8(%ebp)
801046b1:	e8 3a ff ff ff       	call   801045f0 <argint>
801046b6:	83 c4 10             	add    $0x10,%esp
801046b9:	85 c0                	test   %eax,%eax
801046bb:	78 13                	js     801046d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801046bd:	83 ec 08             	sub    $0x8,%esp
801046c0:	ff 75 0c             	pushl  0xc(%ebp)
801046c3:	ff 75 f4             	pushl  -0xc(%ebp)
801046c6:	e8 c5 fe ff ff       	call   80104590 <fetchstr>
801046cb:	83 c4 10             	add    $0x10,%esp
}
801046ce:	c9                   	leave  
801046cf:	c3                   	ret    
801046d0:	c9                   	leave  
    return -1;
801046d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046d6:	c3                   	ret    
801046d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046de:	66 90                	xchg   %ax,%ax

801046e0 <syscall>:
[SYS_getreadcount] sys_getreadcount, //added part
};

void
syscall(void)
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	53                   	push   %ebx
801046e8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801046eb:	e8 60 ef ff ff       	call   80103650 <myproc>
801046f0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801046f2:	8b 40 1c             	mov    0x1c(%eax),%eax
801046f5:	8b 40 1c             	mov    0x1c(%eax),%eax
  
  if (num==SYS_read){
801046f8:	83 f8 05             	cmp    $0x5,%eax
801046fb:	74 53                	je     80104750 <syscall+0x70>
    curproc->readid = curproc->readid + 1; //added part
  }
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801046fd:	8d 50 ff             	lea    -0x1(%eax),%edx
80104700:	83 fa 15             	cmp    $0x15,%edx
80104703:	76 2b                	jbe    80104730 <syscall+0x50>
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104705:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104706:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104709:	50                   	push   %eax
8010470a:	ff 73 14             	pushl  0x14(%ebx)
8010470d:	68 fd 74 10 80       	push   $0x801074fd
80104712:	e8 99 bf ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104717:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010471a:	83 c4 10             	add    $0x10,%esp
8010471d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104727:	c9                   	leave  
80104728:	c3                   	ret    
80104729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104730:	8b 14 85 20 75 10 80 	mov    -0x7fef8ae0(,%eax,4),%edx
80104737:	85 d2                	test   %edx,%edx
80104739:	74 ca                	je     80104705 <syscall+0x25>
    curproc->tf->eax = syscalls[num]();
8010473b:	ff d2                	call   *%edx
8010473d:	89 c2                	mov    %eax,%edx
8010473f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104742:	89 50 1c             	mov    %edx,0x1c(%eax)
}
80104745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104748:	c9                   	leave  
80104749:	c3                   	ret    
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104750:	ba d0 49 10 80       	mov    $0x801049d0,%edx
    curproc->readid = curproc->readid + 1; //added part
80104755:	83 03 01             	addl   $0x1,(%ebx)
    curproc->tf->eax = syscalls[num]();
80104758:	ff d2                	call   *%edx
8010475a:	89 c2                	mov    %eax,%edx
8010475c:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010475f:	89 50 1c             	mov    %edx,0x1c(%eax)
80104762:	eb e1                	jmp    80104745 <syscall+0x65>
80104764:	66 90                	xchg   %ax,%ax
80104766:	66 90                	xchg   %ax,%ax
80104768:	66 90                	xchg   %ax,%ax
8010476a:	66 90                	xchg   %ax,%ax
8010476c:	66 90                	xchg   %ax,%ax
8010476e:	66 90                	xchg   %ax,%ax

80104770 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104775:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104778:	53                   	push   %ebx
80104779:	83 ec 34             	sub    $0x34,%esp
8010477c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010477f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104782:	57                   	push   %edi
80104783:	50                   	push   %eax
{
80104784:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104787:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010478a:	e8 c1 d8 ff ff       	call   80102050 <nameiparent>
8010478f:	83 c4 10             	add    $0x10,%esp
80104792:	85 c0                	test   %eax,%eax
80104794:	0f 84 46 01 00 00    	je     801048e0 <create+0x170>
    return 0;
  ilock(dp);
8010479a:	83 ec 0c             	sub    $0xc,%esp
8010479d:	89 c3                	mov    %eax,%ebx
8010479f:	50                   	push   %eax
801047a0:	e8 bb cf ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801047a5:	83 c4 0c             	add    $0xc,%esp
801047a8:	6a 00                	push   $0x0
801047aa:	57                   	push   %edi
801047ab:	53                   	push   %ebx
801047ac:	e8 ff d4 ff ff       	call   80101cb0 <dirlookup>
801047b1:	83 c4 10             	add    $0x10,%esp
801047b4:	89 c6                	mov    %eax,%esi
801047b6:	85 c0                	test   %eax,%eax
801047b8:	74 56                	je     80104810 <create+0xa0>
    iunlockput(dp);
801047ba:	83 ec 0c             	sub    $0xc,%esp
801047bd:	53                   	push   %ebx
801047be:	e8 3d d2 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
801047c3:	89 34 24             	mov    %esi,(%esp)
801047c6:	e8 95 cf ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801047cb:	83 c4 10             	add    $0x10,%esp
801047ce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801047d3:	75 1b                	jne    801047f0 <create+0x80>
801047d5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801047da:	75 14                	jne    801047f0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801047dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047df:	89 f0                	mov    %esi,%eax
801047e1:	5b                   	pop    %ebx
801047e2:	5e                   	pop    %esi
801047e3:	5f                   	pop    %edi
801047e4:	5d                   	pop    %ebp
801047e5:	c3                   	ret    
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801047f0:	83 ec 0c             	sub    $0xc,%esp
801047f3:	56                   	push   %esi
    return 0;
801047f4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801047f6:	e8 05 d2 ff ff       	call   80101a00 <iunlockput>
    return 0;
801047fb:	83 c4 10             	add    $0x10,%esp
}
801047fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104801:	89 f0                	mov    %esi,%eax
80104803:	5b                   	pop    %ebx
80104804:	5e                   	pop    %esi
80104805:	5f                   	pop    %edi
80104806:	5d                   	pop    %ebp
80104807:	c3                   	ret    
80104808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104810:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104814:	83 ec 08             	sub    $0x8,%esp
80104817:	50                   	push   %eax
80104818:	ff 33                	pushl  (%ebx)
8010481a:	e8 c1 cd ff ff       	call   801015e0 <ialloc>
8010481f:	83 c4 10             	add    $0x10,%esp
80104822:	89 c6                	mov    %eax,%esi
80104824:	85 c0                	test   %eax,%eax
80104826:	0f 84 cd 00 00 00    	je     801048f9 <create+0x189>
  ilock(ip);
8010482c:	83 ec 0c             	sub    $0xc,%esp
8010482f:	50                   	push   %eax
80104830:	e8 2b cf ff ff       	call   80101760 <ilock>
  ip->major = major;
80104835:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104839:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010483d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104841:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104845:	b8 01 00 00 00       	mov    $0x1,%eax
8010484a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010484e:	89 34 24             	mov    %esi,(%esp)
80104851:	e8 4a ce ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104856:	83 c4 10             	add    $0x10,%esp
80104859:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010485e:	74 30                	je     80104890 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104860:	83 ec 04             	sub    $0x4,%esp
80104863:	ff 76 04             	pushl  0x4(%esi)
80104866:	57                   	push   %edi
80104867:	53                   	push   %ebx
80104868:	e8 03 d7 ff ff       	call   80101f70 <dirlink>
8010486d:	83 c4 10             	add    $0x10,%esp
80104870:	85 c0                	test   %eax,%eax
80104872:	78 78                	js     801048ec <create+0x17c>
  iunlockput(dp);
80104874:	83 ec 0c             	sub    $0xc,%esp
80104877:	53                   	push   %ebx
80104878:	e8 83 d1 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010487d:	83 c4 10             	add    $0x10,%esp
}
80104880:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104883:	89 f0                	mov    %esi,%eax
80104885:	5b                   	pop    %ebx
80104886:	5e                   	pop    %esi
80104887:	5f                   	pop    %edi
80104888:	5d                   	pop    %ebp
80104889:	c3                   	ret    
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104890:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104893:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104898:	53                   	push   %ebx
80104899:	e8 02 ce ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010489e:	83 c4 0c             	add    $0xc,%esp
801048a1:	ff 76 04             	pushl  0x4(%esi)
801048a4:	68 98 75 10 80       	push   $0x80107598
801048a9:	56                   	push   %esi
801048aa:	e8 c1 d6 ff ff       	call   80101f70 <dirlink>
801048af:	83 c4 10             	add    $0x10,%esp
801048b2:	85 c0                	test   %eax,%eax
801048b4:	78 18                	js     801048ce <create+0x15e>
801048b6:	83 ec 04             	sub    $0x4,%esp
801048b9:	ff 73 04             	pushl  0x4(%ebx)
801048bc:	68 97 75 10 80       	push   $0x80107597
801048c1:	56                   	push   %esi
801048c2:	e8 a9 d6 ff ff       	call   80101f70 <dirlink>
801048c7:	83 c4 10             	add    $0x10,%esp
801048ca:	85 c0                	test   %eax,%eax
801048cc:	79 92                	jns    80104860 <create+0xf0>
      panic("create dots");
801048ce:	83 ec 0c             	sub    $0xc,%esp
801048d1:	68 8b 75 10 80       	push   $0x8010758b
801048d6:	e8 b5 ba ff ff       	call   80100390 <panic>
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop
}
801048e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801048e3:	31 f6                	xor    %esi,%esi
}
801048e5:	5b                   	pop    %ebx
801048e6:	89 f0                	mov    %esi,%eax
801048e8:	5e                   	pop    %esi
801048e9:	5f                   	pop    %edi
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
    panic("create: dirlink");
801048ec:	83 ec 0c             	sub    $0xc,%esp
801048ef:	68 9a 75 10 80       	push   $0x8010759a
801048f4:	e8 97 ba ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801048f9:	83 ec 0c             	sub    $0xc,%esp
801048fc:	68 7c 75 10 80       	push   $0x8010757c
80104901:	e8 8a ba ff ff       	call   80100390 <panic>
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	89 d6                	mov    %edx,%esi
80104916:	53                   	push   %ebx
80104917:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104919:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010491c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010491f:	50                   	push   %eax
80104920:	6a 00                	push   $0x0
80104922:	e8 c9 fc ff ff       	call   801045f0 <argint>
80104927:	83 c4 10             	add    $0x10,%esp
8010492a:	85 c0                	test   %eax,%eax
8010492c:	78 2a                	js     80104958 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010492e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104932:	77 24                	ja     80104958 <argfd.constprop.0+0x48>
80104934:	e8 17 ed ff ff       	call   80103650 <myproc>
80104939:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010493c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104940:	85 c0                	test   %eax,%eax
80104942:	74 14                	je     80104958 <argfd.constprop.0+0x48>
  if(pfd)
80104944:	85 db                	test   %ebx,%ebx
80104946:	74 02                	je     8010494a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104948:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010494a:	89 06                	mov    %eax,(%esi)
  return 0;
8010494c:	31 c0                	xor    %eax,%eax
}
8010494e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104951:	5b                   	pop    %ebx
80104952:	5e                   	pop    %esi
80104953:	5d                   	pop    %ebp
80104954:	c3                   	ret    
80104955:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010495d:	eb ef                	jmp    8010494e <argfd.constprop.0+0x3e>
8010495f:	90                   	nop

80104960 <sys_dup>:
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104965:	31 c0                	xor    %eax,%eax
{
80104967:	89 e5                	mov    %esp,%ebp
80104969:	56                   	push   %esi
8010496a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010496b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010496e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104971:	e8 9a ff ff ff       	call   80104910 <argfd.constprop.0>
80104976:	85 c0                	test   %eax,%eax
80104978:	78 1e                	js     80104998 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010497a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010497d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010497f:	e8 cc ec ff ff       	call   80103650 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104988:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
8010498c:	85 d2                	test   %edx,%edx
8010498e:	74 20                	je     801049b0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104990:	83 c3 01             	add    $0x1,%ebx
80104993:	83 fb 10             	cmp    $0x10,%ebx
80104996:	75 f0                	jne    80104988 <sys_dup+0x28>
}
80104998:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010499b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801049a0:	89 d8                	mov    %ebx,%eax
801049a2:	5b                   	pop    %ebx
801049a3:	5e                   	pop    %esi
801049a4:	5d                   	pop    %ebp
801049a5:	c3                   	ret    
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801049b0:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
801049b4:	83 ec 0c             	sub    $0xc,%esp
801049b7:	ff 75 f4             	pushl  -0xc(%ebp)
801049ba:	e8 b1 c4 ff ff       	call   80100e70 <filedup>
  return fd;
801049bf:	83 c4 10             	add    $0x10,%esp
}
801049c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049c5:	89 d8                	mov    %ebx,%eax
801049c7:	5b                   	pop    %ebx
801049c8:	5e                   	pop    %esi
801049c9:	5d                   	pop    %ebp
801049ca:	c3                   	ret    
801049cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049cf:	90                   	nop

801049d0 <sys_read>:
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049d5:	31 c0                	xor    %eax,%eax
{
801049d7:	89 e5                	mov    %esp,%ebp
801049d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049dc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049df:	e8 2c ff ff ff       	call   80104910 <argfd.constprop.0>
801049e4:	85 c0                	test   %eax,%eax
801049e6:	78 48                	js     80104a30 <sys_read+0x60>
801049e8:	83 ec 08             	sub    $0x8,%esp
801049eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049ee:	50                   	push   %eax
801049ef:	6a 02                	push   $0x2
801049f1:	e8 fa fb ff ff       	call   801045f0 <argint>
801049f6:	83 c4 10             	add    $0x10,%esp
801049f9:	85 c0                	test   %eax,%eax
801049fb:	78 33                	js     80104a30 <sys_read+0x60>
801049fd:	83 ec 04             	sub    $0x4,%esp
80104a00:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a03:	ff 75 f0             	pushl  -0x10(%ebp)
80104a06:	50                   	push   %eax
80104a07:	6a 01                	push   $0x1
80104a09:	e8 32 fc ff ff       	call   80104640 <argptr>
80104a0e:	83 c4 10             	add    $0x10,%esp
80104a11:	85 c0                	test   %eax,%eax
80104a13:	78 1b                	js     80104a30 <sys_read+0x60>
  return fileread(f, p, n);
80104a15:	83 ec 04             	sub    $0x4,%esp
80104a18:	ff 75 f0             	pushl  -0x10(%ebp)
80104a1b:	ff 75 f4             	pushl  -0xc(%ebp)
80104a1e:	ff 75 ec             	pushl  -0x14(%ebp)
80104a21:	e8 ca c5 ff ff       	call   80100ff0 <fileread>
80104a26:	83 c4 10             	add    $0x10,%esp
}
80104a29:	c9                   	leave  
80104a2a:	c3                   	ret    
80104a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a2f:	90                   	nop
80104a30:	c9                   	leave  
    return -1;
80104a31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a36:	c3                   	ret    
80104a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <sys_write>:
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a45:	31 c0                	xor    %eax,%eax
{
80104a47:	89 e5                	mov    %esp,%ebp
80104a49:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a4c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a4f:	e8 bc fe ff ff       	call   80104910 <argfd.constprop.0>
80104a54:	85 c0                	test   %eax,%eax
80104a56:	78 48                	js     80104aa0 <sys_write+0x60>
80104a58:	83 ec 08             	sub    $0x8,%esp
80104a5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a5e:	50                   	push   %eax
80104a5f:	6a 02                	push   $0x2
80104a61:	e8 8a fb ff ff       	call   801045f0 <argint>
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	85 c0                	test   %eax,%eax
80104a6b:	78 33                	js     80104aa0 <sys_write+0x60>
80104a6d:	83 ec 04             	sub    $0x4,%esp
80104a70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a73:	ff 75 f0             	pushl  -0x10(%ebp)
80104a76:	50                   	push   %eax
80104a77:	6a 01                	push   $0x1
80104a79:	e8 c2 fb ff ff       	call   80104640 <argptr>
80104a7e:	83 c4 10             	add    $0x10,%esp
80104a81:	85 c0                	test   %eax,%eax
80104a83:	78 1b                	js     80104aa0 <sys_write+0x60>
  return filewrite(f, p, n);
80104a85:	83 ec 04             	sub    $0x4,%esp
80104a88:	ff 75 f0             	pushl  -0x10(%ebp)
80104a8b:	ff 75 f4             	pushl  -0xc(%ebp)
80104a8e:	ff 75 ec             	pushl  -0x14(%ebp)
80104a91:	e8 fa c5 ff ff       	call   80101090 <filewrite>
80104a96:	83 c4 10             	add    $0x10,%esp
}
80104a99:	c9                   	leave  
80104a9a:	c3                   	ret    
80104a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop
80104aa0:	c9                   	leave  
    return -1;
80104aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aa6:	c3                   	ret    
80104aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <sys_close>:
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104aba:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104abd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ac0:	e8 4b fe ff ff       	call   80104910 <argfd.constprop.0>
80104ac5:	85 c0                	test   %eax,%eax
80104ac7:	78 27                	js     80104af0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ac9:	e8 82 eb ff ff       	call   80103650 <myproc>
80104ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104ad1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ad4:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104adb:	00 
  fileclose(f);
80104adc:	ff 75 f4             	pushl  -0xc(%ebp)
80104adf:	e8 dc c3 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104ae4:	83 c4 10             	add    $0x10,%esp
80104ae7:	31 c0                	xor    %eax,%eax
}
80104ae9:	c9                   	leave  
80104aea:	c3                   	ret    
80104aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop
80104af0:	c9                   	leave  
    return -1;
80104af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104af6:	c3                   	ret    
80104af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <sys_fstat>:
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b05:	31 c0                	xor    %eax,%eax
{
80104b07:	89 e5                	mov    %esp,%ebp
80104b09:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b0c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b0f:	e8 fc fd ff ff       	call   80104910 <argfd.constprop.0>
80104b14:	85 c0                	test   %eax,%eax
80104b16:	78 30                	js     80104b48 <sys_fstat+0x48>
80104b18:	83 ec 04             	sub    $0x4,%esp
80104b1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b1e:	6a 14                	push   $0x14
80104b20:	50                   	push   %eax
80104b21:	6a 01                	push   $0x1
80104b23:	e8 18 fb ff ff       	call   80104640 <argptr>
80104b28:	83 c4 10             	add    $0x10,%esp
80104b2b:	85 c0                	test   %eax,%eax
80104b2d:	78 19                	js     80104b48 <sys_fstat+0x48>
  return filestat(f, st);
80104b2f:	83 ec 08             	sub    $0x8,%esp
80104b32:	ff 75 f4             	pushl  -0xc(%ebp)
80104b35:	ff 75 f0             	pushl  -0x10(%ebp)
80104b38:	e8 63 c4 ff ff       	call   80100fa0 <filestat>
80104b3d:	83 c4 10             	add    $0x10,%esp
}
80104b40:	c9                   	leave  
80104b41:	c3                   	ret    
80104b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b48:	c9                   	leave  
    return -1;
80104b49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b4e:	c3                   	ret    
80104b4f:	90                   	nop

80104b50 <sys_link>:
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	57                   	push   %edi
80104b58:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104b59:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104b5c:	53                   	push   %ebx
80104b5d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104b60:	50                   	push   %eax
80104b61:	6a 00                	push   $0x0
80104b63:	e8 38 fb ff ff       	call   801046a0 <argstr>
80104b68:	83 c4 10             	add    $0x10,%esp
80104b6b:	85 c0                	test   %eax,%eax
80104b6d:	0f 88 ff 00 00 00    	js     80104c72 <sys_link+0x122>
80104b73:	83 ec 08             	sub    $0x8,%esp
80104b76:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104b79:	50                   	push   %eax
80104b7a:	6a 01                	push   $0x1
80104b7c:	e8 1f fb ff ff       	call   801046a0 <argstr>
80104b81:	83 c4 10             	add    $0x10,%esp
80104b84:	85 c0                	test   %eax,%eax
80104b86:	0f 88 e6 00 00 00    	js     80104c72 <sys_link+0x122>
  begin_op();
80104b8c:	e8 8f de ff ff       	call   80102a20 <begin_op>
  if((ip = namei(old)) == 0){
80104b91:	83 ec 0c             	sub    $0xc,%esp
80104b94:	ff 75 d4             	pushl  -0x2c(%ebp)
80104b97:	e8 94 d4 ff ff       	call   80102030 <namei>
80104b9c:	83 c4 10             	add    $0x10,%esp
80104b9f:	89 c3                	mov    %eax,%ebx
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	0f 84 e8 00 00 00    	je     80104c91 <sys_link+0x141>
  ilock(ip);
80104ba9:	83 ec 0c             	sub    $0xc,%esp
80104bac:	50                   	push   %eax
80104bad:	e8 ae cb ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80104bb2:	83 c4 10             	add    $0x10,%esp
80104bb5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104bba:	0f 84 b9 00 00 00    	je     80104c79 <sys_link+0x129>
  iupdate(ip);
80104bc0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104bc3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104bc8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104bcb:	53                   	push   %ebx
80104bcc:	e8 cf ca ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80104bd1:	89 1c 24             	mov    %ebx,(%esp)
80104bd4:	e8 67 cc ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104bd9:	58                   	pop    %eax
80104bda:	5a                   	pop    %edx
80104bdb:	57                   	push   %edi
80104bdc:	ff 75 d0             	pushl  -0x30(%ebp)
80104bdf:	e8 6c d4 ff ff       	call   80102050 <nameiparent>
80104be4:	83 c4 10             	add    $0x10,%esp
80104be7:	89 c6                	mov    %eax,%esi
80104be9:	85 c0                	test   %eax,%eax
80104beb:	74 5f                	je     80104c4c <sys_link+0xfc>
  ilock(dp);
80104bed:	83 ec 0c             	sub    $0xc,%esp
80104bf0:	50                   	push   %eax
80104bf1:	e8 6a cb ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104bf6:	8b 03                	mov    (%ebx),%eax
80104bf8:	83 c4 10             	add    $0x10,%esp
80104bfb:	39 06                	cmp    %eax,(%esi)
80104bfd:	75 41                	jne    80104c40 <sys_link+0xf0>
80104bff:	83 ec 04             	sub    $0x4,%esp
80104c02:	ff 73 04             	pushl  0x4(%ebx)
80104c05:	57                   	push   %edi
80104c06:	56                   	push   %esi
80104c07:	e8 64 d3 ff ff       	call   80101f70 <dirlink>
80104c0c:	83 c4 10             	add    $0x10,%esp
80104c0f:	85 c0                	test   %eax,%eax
80104c11:	78 2d                	js     80104c40 <sys_link+0xf0>
  iunlockput(dp);
80104c13:	83 ec 0c             	sub    $0xc,%esp
80104c16:	56                   	push   %esi
80104c17:	e8 e4 cd ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80104c1c:	89 1c 24             	mov    %ebx,(%esp)
80104c1f:	e8 6c cc ff ff       	call   80101890 <iput>
  end_op();
80104c24:	e8 67 de ff ff       	call   80102a90 <end_op>
  return 0;
80104c29:	83 c4 10             	add    $0x10,%esp
80104c2c:	31 c0                	xor    %eax,%eax
}
80104c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5f                   	pop    %edi
80104c34:	5d                   	pop    %ebp
80104c35:	c3                   	ret    
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	56                   	push   %esi
80104c44:	e8 b7 cd ff ff       	call   80101a00 <iunlockput>
    goto bad;
80104c49:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	53                   	push   %ebx
80104c50:	e8 0b cb ff ff       	call   80101760 <ilock>
  ip->nlink--;
80104c55:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c5a:	89 1c 24             	mov    %ebx,(%esp)
80104c5d:	e8 3e ca ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80104c62:	89 1c 24             	mov    %ebx,(%esp)
80104c65:	e8 96 cd ff ff       	call   80101a00 <iunlockput>
  end_op();
80104c6a:	e8 21 de ff ff       	call   80102a90 <end_op>
  return -1;
80104c6f:	83 c4 10             	add    $0x10,%esp
80104c72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c77:	eb b5                	jmp    80104c2e <sys_link+0xde>
    iunlockput(ip);
80104c79:	83 ec 0c             	sub    $0xc,%esp
80104c7c:	53                   	push   %ebx
80104c7d:	e8 7e cd ff ff       	call   80101a00 <iunlockput>
    end_op();
80104c82:	e8 09 de ff ff       	call   80102a90 <end_op>
    return -1;
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8f:	eb 9d                	jmp    80104c2e <sys_link+0xde>
    end_op();
80104c91:	e8 fa dd ff ff       	call   80102a90 <end_op>
    return -1;
80104c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c9b:	eb 91                	jmp    80104c2e <sys_link+0xde>
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ca0 <sys_unlink>:
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	57                   	push   %edi
80104ca8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104ca9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104cac:	53                   	push   %ebx
80104cad:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104cb0:	50                   	push   %eax
80104cb1:	6a 00                	push   $0x0
80104cb3:	e8 e8 f9 ff ff       	call   801046a0 <argstr>
80104cb8:	83 c4 10             	add    $0x10,%esp
80104cbb:	85 c0                	test   %eax,%eax
80104cbd:	0f 88 7d 01 00 00    	js     80104e40 <sys_unlink+0x1a0>
  begin_op();
80104cc3:	e8 58 dd ff ff       	call   80102a20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104cc8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104ccb:	83 ec 08             	sub    $0x8,%esp
80104cce:	53                   	push   %ebx
80104ccf:	ff 75 c0             	pushl  -0x40(%ebp)
80104cd2:	e8 79 d3 ff ff       	call   80102050 <nameiparent>
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	89 c6                	mov    %eax,%esi
80104cdc:	85 c0                	test   %eax,%eax
80104cde:	0f 84 66 01 00 00    	je     80104e4a <sys_unlink+0x1aa>
  ilock(dp);
80104ce4:	83 ec 0c             	sub    $0xc,%esp
80104ce7:	50                   	push   %eax
80104ce8:	e8 73 ca ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ced:	58                   	pop    %eax
80104cee:	5a                   	pop    %edx
80104cef:	68 98 75 10 80       	push   $0x80107598
80104cf4:	53                   	push   %ebx
80104cf5:	e8 96 cf ff ff       	call   80101c90 <namecmp>
80104cfa:	83 c4 10             	add    $0x10,%esp
80104cfd:	85 c0                	test   %eax,%eax
80104cff:	0f 84 03 01 00 00    	je     80104e08 <sys_unlink+0x168>
80104d05:	83 ec 08             	sub    $0x8,%esp
80104d08:	68 97 75 10 80       	push   $0x80107597
80104d0d:	53                   	push   %ebx
80104d0e:	e8 7d cf ff ff       	call   80101c90 <namecmp>
80104d13:	83 c4 10             	add    $0x10,%esp
80104d16:	85 c0                	test   %eax,%eax
80104d18:	0f 84 ea 00 00 00    	je     80104e08 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104d1e:	83 ec 04             	sub    $0x4,%esp
80104d21:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d24:	50                   	push   %eax
80104d25:	53                   	push   %ebx
80104d26:	56                   	push   %esi
80104d27:	e8 84 cf ff ff       	call   80101cb0 <dirlookup>
80104d2c:	83 c4 10             	add    $0x10,%esp
80104d2f:	89 c3                	mov    %eax,%ebx
80104d31:	85 c0                	test   %eax,%eax
80104d33:	0f 84 cf 00 00 00    	je     80104e08 <sys_unlink+0x168>
  ilock(ip);
80104d39:	83 ec 0c             	sub    $0xc,%esp
80104d3c:	50                   	push   %eax
80104d3d:	e8 1e ca ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d4a:	0f 8e 23 01 00 00    	jle    80104e73 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d55:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104d58:	74 66                	je     80104dc0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104d5a:	83 ec 04             	sub    $0x4,%esp
80104d5d:	6a 10                	push   $0x10
80104d5f:	6a 00                	push   $0x0
80104d61:	57                   	push   %edi
80104d62:	e8 a9 f5 ff ff       	call   80104310 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d67:	6a 10                	push   $0x10
80104d69:	ff 75 c4             	pushl  -0x3c(%ebp)
80104d6c:	57                   	push   %edi
80104d6d:	56                   	push   %esi
80104d6e:	e8 ed cd ff ff       	call   80101b60 <writei>
80104d73:	83 c4 20             	add    $0x20,%esp
80104d76:	83 f8 10             	cmp    $0x10,%eax
80104d79:	0f 85 e7 00 00 00    	jne    80104e66 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80104d7f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d84:	0f 84 96 00 00 00    	je     80104e20 <sys_unlink+0x180>
  iunlockput(dp);
80104d8a:	83 ec 0c             	sub    $0xc,%esp
80104d8d:	56                   	push   %esi
80104d8e:	e8 6d cc ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80104d93:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d98:	89 1c 24             	mov    %ebx,(%esp)
80104d9b:	e8 00 c9 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80104da0:	89 1c 24             	mov    %ebx,(%esp)
80104da3:	e8 58 cc ff ff       	call   80101a00 <iunlockput>
  end_op();
80104da8:	e8 e3 dc ff ff       	call   80102a90 <end_op>
  return 0;
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	31 c0                	xor    %eax,%eax
}
80104db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104db5:	5b                   	pop    %ebx
80104db6:	5e                   	pop    %esi
80104db7:	5f                   	pop    %edi
80104db8:	5d                   	pop    %ebp
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104dc0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104dc4:	76 94                	jbe    80104d5a <sys_unlink+0xba>
80104dc6:	ba 20 00 00 00       	mov    $0x20,%edx
80104dcb:	eb 0b                	jmp    80104dd8 <sys_unlink+0x138>
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
80104dd0:	83 c2 10             	add    $0x10,%edx
80104dd3:	39 53 58             	cmp    %edx,0x58(%ebx)
80104dd6:	76 82                	jbe    80104d5a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dd8:	6a 10                	push   $0x10
80104dda:	52                   	push   %edx
80104ddb:	57                   	push   %edi
80104ddc:	53                   	push   %ebx
80104ddd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104de0:	e8 7b cc ff ff       	call   80101a60 <readi>
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80104deb:	83 f8 10             	cmp    $0x10,%eax
80104dee:	75 69                	jne    80104e59 <sys_unlink+0x1b9>
    if(de.inum != 0)
80104df0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104df5:	74 d9                	je     80104dd0 <sys_unlink+0x130>
    iunlockput(ip);
80104df7:	83 ec 0c             	sub    $0xc,%esp
80104dfa:	53                   	push   %ebx
80104dfb:	e8 00 cc ff ff       	call   80101a00 <iunlockput>
    goto bad;
80104e00:	83 c4 10             	add    $0x10,%esp
80104e03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e07:	90                   	nop
  iunlockput(dp);
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	56                   	push   %esi
80104e0c:	e8 ef cb ff ff       	call   80101a00 <iunlockput>
  end_op();
80104e11:	e8 7a dc ff ff       	call   80102a90 <end_op>
  return -1;
80104e16:	83 c4 10             	add    $0x10,%esp
80104e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e1e:	eb 92                	jmp    80104db2 <sys_unlink+0x112>
    iupdate(dp);
80104e20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80104e23:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80104e28:	56                   	push   %esi
80104e29:	e8 72 c8 ff ff       	call   801016a0 <iupdate>
80104e2e:	83 c4 10             	add    $0x10,%esp
80104e31:	e9 54 ff ff ff       	jmp    80104d8a <sys_unlink+0xea>
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e45:	e9 68 ff ff ff       	jmp    80104db2 <sys_unlink+0x112>
    end_op();
80104e4a:	e8 41 dc ff ff       	call   80102a90 <end_op>
    return -1;
80104e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e54:	e9 59 ff ff ff       	jmp    80104db2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80104e59:	83 ec 0c             	sub    $0xc,%esp
80104e5c:	68 bc 75 10 80       	push   $0x801075bc
80104e61:	e8 2a b5 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80104e66:	83 ec 0c             	sub    $0xc,%esp
80104e69:	68 ce 75 10 80       	push   $0x801075ce
80104e6e:	e8 1d b5 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80104e73:	83 ec 0c             	sub    $0xc,%esp
80104e76:	68 aa 75 10 80       	push   $0x801075aa
80104e7b:	e8 10 b5 ff ff       	call   80100390 <panic>

80104e80 <sys_open>:

int
sys_open(void)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	57                   	push   %edi
80104e88:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e89:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80104e8c:	53                   	push   %ebx
80104e8d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e90:	50                   	push   %eax
80104e91:	6a 00                	push   $0x0
80104e93:	e8 08 f8 ff ff       	call   801046a0 <argstr>
80104e98:	83 c4 10             	add    $0x10,%esp
80104e9b:	85 c0                	test   %eax,%eax
80104e9d:	0f 88 8a 00 00 00    	js     80104f2d <sys_open+0xad>
80104ea3:	83 ec 08             	sub    $0x8,%esp
80104ea6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ea9:	50                   	push   %eax
80104eaa:	6a 01                	push   $0x1
80104eac:	e8 3f f7 ff ff       	call   801045f0 <argint>
80104eb1:	83 c4 10             	add    $0x10,%esp
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	78 75                	js     80104f2d <sys_open+0xad>
    return -1;

  begin_op();
80104eb8:	e8 63 db ff ff       	call   80102a20 <begin_op>

  if(omode & O_CREATE){
80104ebd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104ec1:	75 75                	jne    80104f38 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104ec3:	83 ec 0c             	sub    $0xc,%esp
80104ec6:	ff 75 e0             	pushl  -0x20(%ebp)
80104ec9:	e8 62 d1 ff ff       	call   80102030 <namei>
80104ece:	83 c4 10             	add    $0x10,%esp
80104ed1:	89 c6                	mov    %eax,%esi
80104ed3:	85 c0                	test   %eax,%eax
80104ed5:	74 7e                	je     80104f55 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80104ed7:	83 ec 0c             	sub    $0xc,%esp
80104eda:	50                   	push   %eax
80104edb:	e8 80 c8 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ee0:	83 c4 10             	add    $0x10,%esp
80104ee3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104ee8:	0f 84 c2 00 00 00    	je     80104fb0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104eee:	e8 0d bf ff ff       	call   80100e00 <filealloc>
80104ef3:	89 c7                	mov    %eax,%edi
80104ef5:	85 c0                	test   %eax,%eax
80104ef7:	74 23                	je     80104f1c <sys_open+0x9c>
  struct proc *curproc = myproc();
80104ef9:	e8 52 e7 ff ff       	call   80103650 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104efe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80104f00:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104f04:	85 d2                	test   %edx,%edx
80104f06:	74 60                	je     80104f68 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80104f08:	83 c3 01             	add    $0x1,%ebx
80104f0b:	83 fb 10             	cmp    $0x10,%ebx
80104f0e:	75 f0                	jne    80104f00 <sys_open+0x80>
    if(f)
      fileclose(f);
80104f10:	83 ec 0c             	sub    $0xc,%esp
80104f13:	57                   	push   %edi
80104f14:	e8 a7 bf ff ff       	call   80100ec0 <fileclose>
80104f19:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	56                   	push   %esi
80104f20:	e8 db ca ff ff       	call   80101a00 <iunlockput>
    end_op();
80104f25:	e8 66 db ff ff       	call   80102a90 <end_op>
    return -1;
80104f2a:	83 c4 10             	add    $0x10,%esp
80104f2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104f32:	eb 6d                	jmp    80104fa1 <sys_open+0x121>
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80104f38:	83 ec 0c             	sub    $0xc,%esp
80104f3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f3e:	31 c9                	xor    %ecx,%ecx
80104f40:	ba 02 00 00 00       	mov    $0x2,%edx
80104f45:	6a 00                	push   $0x0
80104f47:	e8 24 f8 ff ff       	call   80104770 <create>
    if(ip == 0){
80104f4c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80104f4f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104f51:	85 c0                	test   %eax,%eax
80104f53:	75 99                	jne    80104eee <sys_open+0x6e>
      end_op();
80104f55:	e8 36 db ff ff       	call   80102a90 <end_op>
      return -1;
80104f5a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104f5f:	eb 40                	jmp    80104fa1 <sys_open+0x121>
80104f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80104f68:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f6b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80104f6f:	56                   	push   %esi
80104f70:	e8 cb c8 ff ff       	call   80101840 <iunlock>
  end_op();
80104f75:	e8 16 db ff ff       	call   80102a90 <end_op>

  f->type = FD_INODE;
80104f7a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f83:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80104f86:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80104f89:	89 d0                	mov    %edx,%eax
  f->off = 0;
80104f8b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80104f92:	f7 d0                	not    %eax
80104f94:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f97:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80104f9a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f9d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80104fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fa4:	89 d8                	mov    %ebx,%eax
80104fa6:	5b                   	pop    %ebx
80104fa7:	5e                   	pop    %esi
80104fa8:	5f                   	pop    %edi
80104fa9:	5d                   	pop    %ebp
80104faa:	c3                   	ret    
80104fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fb0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104fb3:	85 c9                	test   %ecx,%ecx
80104fb5:	0f 84 33 ff ff ff    	je     80104eee <sys_open+0x6e>
80104fbb:	e9 5c ff ff ff       	jmp    80104f1c <sys_open+0x9c>

80104fc0 <sys_mkdir>:

int
sys_mkdir(void)
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104fca:	e8 51 da ff ff       	call   80102a20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104fcf:	83 ec 08             	sub    $0x8,%esp
80104fd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fd5:	50                   	push   %eax
80104fd6:	6a 00                	push   $0x0
80104fd8:	e8 c3 f6 ff ff       	call   801046a0 <argstr>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	78 34                	js     80105018 <sys_mkdir+0x58>
80104fe4:	83 ec 0c             	sub    $0xc,%esp
80104fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fea:	31 c9                	xor    %ecx,%ecx
80104fec:	ba 01 00 00 00       	mov    $0x1,%edx
80104ff1:	6a 00                	push   $0x0
80104ff3:	e8 78 f7 ff ff       	call   80104770 <create>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	74 19                	je     80105018 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fff:	83 ec 0c             	sub    $0xc,%esp
80105002:	50                   	push   %eax
80105003:	e8 f8 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105008:	e8 83 da ff ff       	call   80102a90 <end_op>
  return 0;
8010500d:	83 c4 10             	add    $0x10,%esp
80105010:	31 c0                	xor    %eax,%eax
}
80105012:	c9                   	leave  
80105013:	c3                   	ret    
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105018:	e8 73 da ff ff       	call   80102a90 <end_op>
    return -1;
8010501d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105022:	c9                   	leave  
80105023:	c3                   	ret    
80105024:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010502f:	90                   	nop

80105030 <sys_mknod>:

int
sys_mknod(void)
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010503a:	e8 e1 d9 ff ff       	call   80102a20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010503f:	83 ec 08             	sub    $0x8,%esp
80105042:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105045:	50                   	push   %eax
80105046:	6a 00                	push   $0x0
80105048:	e8 53 f6 ff ff       	call   801046a0 <argstr>
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	85 c0                	test   %eax,%eax
80105052:	78 64                	js     801050b8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105054:	83 ec 08             	sub    $0x8,%esp
80105057:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010505a:	50                   	push   %eax
8010505b:	6a 01                	push   $0x1
8010505d:	e8 8e f5 ff ff       	call   801045f0 <argint>
  if((argstr(0, &path)) < 0 ||
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	85 c0                	test   %eax,%eax
80105067:	78 4f                	js     801050b8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105069:	83 ec 08             	sub    $0x8,%esp
8010506c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010506f:	50                   	push   %eax
80105070:	6a 02                	push   $0x2
80105072:	e8 79 f5 ff ff       	call   801045f0 <argint>
     argint(1, &major) < 0 ||
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	78 3a                	js     801050b8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010507e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105089:	ba 03 00 00 00       	mov    $0x3,%edx
8010508e:	50                   	push   %eax
8010508f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105092:	e8 d9 f6 ff ff       	call   80104770 <create>
     argint(2, &minor) < 0 ||
80105097:	83 c4 10             	add    $0x10,%esp
8010509a:	85 c0                	test   %eax,%eax
8010509c:	74 1a                	je     801050b8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010509e:	83 ec 0c             	sub    $0xc,%esp
801050a1:	50                   	push   %eax
801050a2:	e8 59 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
801050a7:	e8 e4 d9 ff ff       	call   80102a90 <end_op>
  return 0;
801050ac:	83 c4 10             	add    $0x10,%esp
801050af:	31 c0                	xor    %eax,%eax
}
801050b1:	c9                   	leave  
801050b2:	c3                   	ret    
801050b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050b7:	90                   	nop
    end_op();
801050b8:	e8 d3 d9 ff ff       	call   80102a90 <end_op>
    return -1;
801050bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c2:	c9                   	leave  
801050c3:	c3                   	ret    
801050c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050cf:	90                   	nop

801050d0 <sys_chdir>:

int
sys_chdir(void)
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
801050d5:	89 e5                	mov    %esp,%ebp
801050d7:	56                   	push   %esi
801050d8:	53                   	push   %ebx
801050d9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801050dc:	e8 6f e5 ff ff       	call   80103650 <myproc>
801050e1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801050e3:	e8 38 d9 ff ff       	call   80102a20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801050e8:	83 ec 08             	sub    $0x8,%esp
801050eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ee:	50                   	push   %eax
801050ef:	6a 00                	push   $0x0
801050f1:	e8 aa f5 ff ff       	call   801046a0 <argstr>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	85 c0                	test   %eax,%eax
801050fb:	78 73                	js     80105170 <sys_chdir+0xa0>
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	ff 75 f4             	pushl  -0xc(%ebp)
80105103:	e8 28 cf ff ff       	call   80102030 <namei>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	89 c3                	mov    %eax,%ebx
8010510d:	85 c0                	test   %eax,%eax
8010510f:	74 5f                	je     80105170 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105111:	83 ec 0c             	sub    $0xc,%esp
80105114:	50                   	push   %eax
80105115:	e8 46 c6 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010511a:	83 c4 10             	add    $0x10,%esp
8010511d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105122:	75 2c                	jne    80105150 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	53                   	push   %ebx
80105128:	e8 13 c7 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010512d:	58                   	pop    %eax
8010512e:	ff 76 6c             	pushl  0x6c(%esi)
80105131:	e8 5a c7 ff ff       	call   80101890 <iput>
  end_op();
80105136:	e8 55 d9 ff ff       	call   80102a90 <end_op>
  curproc->cwd = ip;
8010513b:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	31 c0                	xor    %eax,%eax
}
80105143:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105146:	5b                   	pop    %ebx
80105147:	5e                   	pop    %esi
80105148:	5d                   	pop    %ebp
80105149:	c3                   	ret    
8010514a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105150:	83 ec 0c             	sub    $0xc,%esp
80105153:	53                   	push   %ebx
80105154:	e8 a7 c8 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105159:	e8 32 d9 ff ff       	call   80102a90 <end_op>
    return -1;
8010515e:	83 c4 10             	add    $0x10,%esp
80105161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105166:	eb db                	jmp    80105143 <sys_chdir+0x73>
80105168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516f:	90                   	nop
    end_op();
80105170:	e8 1b d9 ff ff       	call   80102a90 <end_op>
    return -1;
80105175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517a:	eb c7                	jmp    80105143 <sys_chdir+0x73>
8010517c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105180 <sys_exec>:

int
sys_exec(void)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	57                   	push   %edi
80105188:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105189:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010518f:	53                   	push   %ebx
80105190:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105196:	50                   	push   %eax
80105197:	6a 00                	push   $0x0
80105199:	e8 02 f5 ff ff       	call   801046a0 <argstr>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	85 c0                	test   %eax,%eax
801051a3:	0f 88 8b 00 00 00    	js     80105234 <sys_exec+0xb4>
801051a9:	83 ec 08             	sub    $0x8,%esp
801051ac:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051b2:	50                   	push   %eax
801051b3:	6a 01                	push   $0x1
801051b5:	e8 36 f4 ff ff       	call   801045f0 <argint>
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 c0                	test   %eax,%eax
801051bf:	78 73                	js     80105234 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051c1:	83 ec 04             	sub    $0x4,%esp
801051c4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801051ca:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801051cc:	68 80 00 00 00       	push   $0x80
801051d1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801051d7:	6a 00                	push   $0x0
801051d9:	50                   	push   %eax
801051da:	e8 31 f1 ff ff       	call   80104310 <memset>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801051e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801051ee:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801051f5:	83 ec 08             	sub    $0x8,%esp
801051f8:	57                   	push   %edi
801051f9:	01 f0                	add    %esi,%eax
801051fb:	50                   	push   %eax
801051fc:	e8 4f f3 ff ff       	call   80104550 <fetchint>
80105201:	83 c4 10             	add    $0x10,%esp
80105204:	85 c0                	test   %eax,%eax
80105206:	78 2c                	js     80105234 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105208:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010520e:	85 c0                	test   %eax,%eax
80105210:	74 36                	je     80105248 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105212:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105218:	83 ec 08             	sub    $0x8,%esp
8010521b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010521e:	52                   	push   %edx
8010521f:	50                   	push   %eax
80105220:	e8 6b f3 ff ff       	call   80104590 <fetchstr>
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	85 c0                	test   %eax,%eax
8010522a:	78 08                	js     80105234 <sys_exec+0xb4>
  for(i=0;; i++){
8010522c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010522f:	83 fb 20             	cmp    $0x20,%ebx
80105232:	75 b4                	jne    801051e8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105234:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010523c:	5b                   	pop    %ebx
8010523d:	5e                   	pop    %esi
8010523e:	5f                   	pop    %edi
8010523f:	5d                   	pop    %ebp
80105240:	c3                   	ret    
80105241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105248:	83 ec 08             	sub    $0x8,%esp
8010524b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105251:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105258:	00 00 00 00 
  return exec(path, argv);
8010525c:	50                   	push   %eax
8010525d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105263:	e8 18 b8 ff ff       	call   80100a80 <exec>
80105268:	83 c4 10             	add    $0x10,%esp
}
8010526b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010526e:	5b                   	pop    %ebx
8010526f:	5e                   	pop    %esi
80105270:	5f                   	pop    %edi
80105271:	5d                   	pop    %ebp
80105272:	c3                   	ret    
80105273:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105280 <sys_pipe>:

int
sys_pipe(void)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	57                   	push   %edi
80105288:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105289:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010528c:	53                   	push   %ebx
8010528d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105290:	6a 08                	push   $0x8
80105292:	50                   	push   %eax
80105293:	6a 00                	push   $0x0
80105295:	e8 a6 f3 ff ff       	call   80104640 <argptr>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	85 c0                	test   %eax,%eax
8010529f:	78 4e                	js     801052ef <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052a1:	83 ec 08             	sub    $0x8,%esp
801052a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052a7:	50                   	push   %eax
801052a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052ab:	50                   	push   %eax
801052ac:	e8 2f de ff ff       	call   801030e0 <pipealloc>
801052b1:	83 c4 10             	add    $0x10,%esp
801052b4:	85 c0                	test   %eax,%eax
801052b6:	78 37                	js     801052ef <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801052bb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801052bd:	e8 8e e3 ff ff       	call   80103650 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801052c8:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
801052cc:	85 f6                	test   %esi,%esi
801052ce:	74 30                	je     80105300 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801052d0:	83 c3 01             	add    $0x1,%ebx
801052d3:	83 fb 10             	cmp    $0x10,%ebx
801052d6:	75 f0                	jne    801052c8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801052d8:	83 ec 0c             	sub    $0xc,%esp
801052db:	ff 75 e0             	pushl  -0x20(%ebp)
801052de:	e8 dd bb ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801052e3:	58                   	pop    %eax
801052e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801052e7:	e8 d4 bb ff ff       	call   80100ec0 <fileclose>
    return -1;
801052ec:	83 c4 10             	add    $0x10,%esp
801052ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f4:	eb 5b                	jmp    80105351 <sys_pipe+0xd1>
801052f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105300:	8d 73 08             	lea    0x8(%ebx),%esi
80105303:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010530a:	e8 41 e3 ff ff       	call   80103650 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010530f:	31 d2                	xor    %edx,%edx
80105311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105318:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
8010531c:	85 c9                	test   %ecx,%ecx
8010531e:	74 20                	je     80105340 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105320:	83 c2 01             	add    $0x1,%edx
80105323:	83 fa 10             	cmp    $0x10,%edx
80105326:	75 f0                	jne    80105318 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105328:	e8 23 e3 ff ff       	call   80103650 <myproc>
8010532d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105334:	00 
80105335:	eb a1                	jmp    801052d8 <sys_pipe+0x58>
80105337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105340:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105344:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105347:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105349:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010534c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010534f:	31 c0                	xor    %eax,%eax
}
80105351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105354:	5b                   	pop    %ebx
80105355:	5e                   	pop    %esi
80105356:	5f                   	pop    %edi
80105357:	5d                   	pop    %ebp
80105358:	c3                   	ret    
80105359:	66 90                	xchg   %ax,%ax
8010535b:	66 90                	xchg   %ax,%ax
8010535d:	66 90                	xchg   %ax,%ax
8010535f:	90                   	nop

80105360 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105360:	f3 0f 1e fb          	endbr32 
  return fork();
80105364:	e9 87 e4 ff ff       	jmp    801037f0 <fork>
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_exit>:
}

int
sys_exit(void)
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	83 ec 08             	sub    $0x8,%esp
  exit();
8010537a:	e8 e1 e6 ff ff       	call   80103a60 <exit>
  return 0;  // not reached
}
8010537f:	31 c0                	xor    %eax,%eax
80105381:	c9                   	leave  
80105382:	c3                   	ret    
80105383:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105390 <sys_wait>:

int
sys_wait(void)
{
80105390:	f3 0f 1e fb          	endbr32 
  return wait();
80105394:	e9 f7 e8 ff ff       	jmp    80103c90 <wait>
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_kill>:
}

int
sys_kill(void)
{
801053a0:	f3 0f 1e fb          	endbr32 
801053a4:	55                   	push   %ebp
801053a5:	89 e5                	mov    %esp,%ebp
801053a7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801053aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ad:	50                   	push   %eax
801053ae:	6a 00                	push   $0x0
801053b0:	e8 3b f2 ff ff       	call   801045f0 <argint>
801053b5:	83 c4 10             	add    $0x10,%esp
801053b8:	85 c0                	test   %eax,%eax
801053ba:	78 14                	js     801053d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801053bc:	83 ec 0c             	sub    $0xc,%esp
801053bf:	ff 75 f4             	pushl  -0xc(%ebp)
801053c2:	e8 19 ea ff ff       	call   80103de0 <kill>
801053c7:	83 c4 10             	add    $0x10,%esp
}
801053ca:	c9                   	leave  
801053cb:	c3                   	ret    
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053d0:	c9                   	leave  
    return -1;
801053d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d6:	c3                   	ret    
801053d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053de:	66 90                	xchg   %ax,%ax

801053e0 <sys_getpid>:

int
sys_getpid(void)
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
801053e5:	89 e5                	mov    %esp,%ebp
801053e7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801053ea:	e8 61 e2 ff ff       	call   80103650 <myproc>
801053ef:	8b 40 14             	mov    0x14(%eax),%eax
}
801053f2:	c9                   	leave  
801053f3:	c3                   	ret    
801053f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ff:	90                   	nop

80105400 <sys_getreadcount>:

int
sys_getreadcount(void)
{
80105400:	f3 0f 1e fb          	endbr32 
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	83 ec 08             	sub    $0x8,%esp
  return myproc()->readid;
8010540a:	e8 41 e2 ff ff       	call   80103650 <myproc>
8010540f:	8b 00                	mov    (%eax),%eax
}
80105411:	c9                   	leave  
80105412:	c3                   	ret    
80105413:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105420 <sys_sbrk>:

int
sys_sbrk(void)
{
80105420:	f3 0f 1e fb          	endbr32 
80105424:	55                   	push   %ebp
80105425:	89 e5                	mov    %esp,%ebp
80105427:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105428:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010542b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010542e:	50                   	push   %eax
8010542f:	6a 00                	push   $0x0
80105431:	e8 ba f1 ff ff       	call   801045f0 <argint>
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	85 c0                	test   %eax,%eax
8010543b:	78 23                	js     80105460 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010543d:	e8 0e e2 ff ff       	call   80103650 <myproc>
  if(growproc(n) < 0)
80105442:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105445:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc(n) < 0)
80105448:	ff 75 f4             	pushl  -0xc(%ebp)
8010544b:	e8 30 e3 ff ff       	call   80103780 <growproc>
80105450:	83 c4 10             	add    $0x10,%esp
80105453:	85 c0                	test   %eax,%eax
80105455:	78 09                	js     80105460 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105457:	89 d8                	mov    %ebx,%eax
80105459:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010545c:	c9                   	leave  
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax
    return -1;
80105460:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105465:	eb f0                	jmp    80105457 <sys_sbrk+0x37>
80105467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546e:	66 90                	xchg   %ax,%ax

80105470 <sys_sleep>:

int
sys_sleep(void)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105478:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010547b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010547e:	50                   	push   %eax
8010547f:	6a 00                	push   $0x0
80105481:	e8 6a f1 ff ff       	call   801045f0 <argint>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	0f 88 86 00 00 00    	js     80105517 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105491:	83 ec 0c             	sub    $0xc,%esp
80105494:	68 20 1d 19 80       	push   $0x80191d20
80105499:	e8 62 ed ff ff       	call   80104200 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010549e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801054a1:	8b 1d 60 25 19 80    	mov    0x80192560,%ebx
  while(ticks - ticks0 < n){
801054a7:	83 c4 10             	add    $0x10,%esp
801054aa:	85 d2                	test   %edx,%edx
801054ac:	75 23                	jne    801054d1 <sys_sleep+0x61>
801054ae:	eb 50                	jmp    80105500 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801054b0:	83 ec 08             	sub    $0x8,%esp
801054b3:	68 20 1d 19 80       	push   $0x80191d20
801054b8:	68 60 25 19 80       	push   $0x80192560
801054bd:	e8 0e e7 ff ff       	call   80103bd0 <sleep>
  while(ticks - ticks0 < n){
801054c2:	a1 60 25 19 80       	mov    0x80192560,%eax
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	29 d8                	sub    %ebx,%eax
801054cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054cf:	73 2f                	jae    80105500 <sys_sleep+0x90>
    if(myproc()->killed){
801054d1:	e8 7a e1 ff ff       	call   80103650 <myproc>
801054d6:	8b 40 28             	mov    0x28(%eax),%eax
801054d9:	85 c0                	test   %eax,%eax
801054db:	74 d3                	je     801054b0 <sys_sleep+0x40>
      release(&tickslock);
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	68 20 1d 19 80       	push   $0x80191d20
801054e5:	e8 d6 ed ff ff       	call   801042c0 <release>
  }
  release(&tickslock);
  return 0;
}
801054ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801054ed:	83 c4 10             	add    $0x10,%esp
801054f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    
801054f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	68 20 1d 19 80       	push   $0x80191d20
80105508:	e8 b3 ed ff ff       	call   801042c0 <release>
  return 0;
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	31 c0                	xor    %eax,%eax
}
80105512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105515:	c9                   	leave  
80105516:	c3                   	ret    
    return -1;
80105517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551c:	eb f4                	jmp    80105512 <sys_sleep+0xa2>
8010551e:	66 90                	xchg   %ax,%ax

80105520 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	53                   	push   %ebx
80105528:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010552b:	68 20 1d 19 80       	push   $0x80191d20
80105530:	e8 cb ec ff ff       	call   80104200 <acquire>
  xticks = ticks;
80105535:	8b 1d 60 25 19 80    	mov    0x80192560,%ebx
  release(&tickslock);
8010553b:	c7 04 24 20 1d 19 80 	movl   $0x80191d20,(%esp)
80105542:	e8 79 ed ff ff       	call   801042c0 <release>
  return xticks;
}
80105547:	89 d8                	mov    %ebx,%eax
80105549:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010554c:	c9                   	leave  
8010554d:	c3                   	ret    

8010554e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010554e:	1e                   	push   %ds
  pushl %es
8010554f:	06                   	push   %es
  pushl %fs
80105550:	0f a0                	push   %fs
  pushl %gs
80105552:	0f a8                	push   %gs
  pushal
80105554:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105555:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105559:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010555b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010555d:	54                   	push   %esp
  call trap
8010555e:	e8 cd 00 00 00       	call   80105630 <trap>
  addl $4, %esp
80105563:	83 c4 04             	add    $0x4,%esp

80105566 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105566:	61                   	popa   
  popl %gs
80105567:	0f a9                	pop    %gs
  popl %fs
80105569:	0f a1                	pop    %fs
  popl %es
8010556b:	07                   	pop    %es
  popl %ds
8010556c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010556d:	83 c4 08             	add    $0x8,%esp
  iret
80105570:	cf                   	iret   
80105571:	66 90                	xchg   %ax,%ax
80105573:	66 90                	xchg   %ax,%ax
80105575:	66 90                	xchg   %ax,%ax
80105577:	66 90                	xchg   %ax,%ax
80105579:	66 90                	xchg   %ax,%ax
8010557b:	66 90                	xchg   %ax,%ax
8010557d:	66 90                	xchg   %ax,%ax
8010557f:	90                   	nop

80105580 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105585:	31 c0                	xor    %eax,%eax
{
80105587:	89 e5                	mov    %esp,%ebp
80105589:	83 ec 08             	sub    $0x8,%esp
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105590:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105597:	c7 04 c5 62 1d 19 80 	movl   $0x8e000008,-0x7fe6e29e(,%eax,8)
8010559e:	08 00 00 8e 
801055a2:	66 89 14 c5 60 1d 19 	mov    %dx,-0x7fe6e2a0(,%eax,8)
801055a9:	80 
801055aa:	c1 ea 10             	shr    $0x10,%edx
801055ad:	66 89 14 c5 66 1d 19 	mov    %dx,-0x7fe6e29a(,%eax,8)
801055b4:	80 
  for(i = 0; i < 256; i++)
801055b5:	83 c0 01             	add    $0x1,%eax
801055b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801055bd:	75 d1                	jne    80105590 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801055bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055c2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801055c7:	c7 05 62 1f 19 80 08 	movl   $0xef000008,0x80191f62
801055ce:	00 00 ef 
  initlock(&tickslock, "time");
801055d1:	68 dd 75 10 80       	push   $0x801075dd
801055d6:	68 20 1d 19 80       	push   $0x80191d20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055db:	66 a3 60 1f 19 80    	mov    %ax,0x80191f60
801055e1:	c1 e8 10             	shr    $0x10,%eax
801055e4:	66 a3 66 1f 19 80    	mov    %ax,0x80191f66
  initlock(&tickslock, "time");
801055ea:	e8 91 ea ff ff       	call   80104080 <initlock>
}
801055ef:	83 c4 10             	add    $0x10,%esp
801055f2:	c9                   	leave  
801055f3:	c3                   	ret    
801055f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop

80105600 <idtinit>:

void
idtinit(void)
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
  pd[0] = size-1;
80105605:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010560a:	89 e5                	mov    %esp,%ebp
8010560c:	83 ec 10             	sub    $0x10,%esp
8010560f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105613:	b8 60 1d 19 80       	mov    $0x80191d60,%eax
80105618:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010561c:	c1 e8 10             	shr    $0x10,%eax
8010561f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105623:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105626:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105629:	c9                   	leave  
8010562a:	c3                   	ret    
8010562b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010562f:	90                   	nop

80105630 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	57                   	push   %edi
80105638:	56                   	push   %esi
80105639:	53                   	push   %ebx
8010563a:	83 ec 1c             	sub    $0x1c,%esp
8010563d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105640:	8b 43 30             	mov    0x30(%ebx),%eax
80105643:	83 f8 40             	cmp    $0x40,%eax
80105646:	0f 84 bc 01 00 00    	je     80105808 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010564c:	83 e8 20             	sub    $0x20,%eax
8010564f:	83 f8 1f             	cmp    $0x1f,%eax
80105652:	77 08                	ja     8010565c <trap+0x2c>
80105654:	3e ff 24 85 84 76 10 	notrack jmp *-0x7fef897c(,%eax,4)
8010565b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010565c:	e8 ef df ff ff       	call   80103650 <myproc>
80105661:	8b 7b 38             	mov    0x38(%ebx),%edi
80105664:	85 c0                	test   %eax,%eax
80105666:	0f 84 eb 01 00 00    	je     80105857 <trap+0x227>
8010566c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105670:	0f 84 e1 01 00 00    	je     80105857 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105676:	0f 20 d1             	mov    %cr2,%ecx
80105679:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010567c:	e8 af df ff ff       	call   80103630 <cpuid>
80105681:	8b 73 30             	mov    0x30(%ebx),%esi
80105684:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105687:	8b 43 34             	mov    0x34(%ebx),%eax
8010568a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010568d:	e8 be df ff ff       	call   80103650 <myproc>
80105692:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105695:	e8 b6 df ff ff       	call   80103650 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010569a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010569d:	8b 55 dc             	mov    -0x24(%ebp),%edx
801056a0:	51                   	push   %ecx
801056a1:	57                   	push   %edi
801056a2:	52                   	push   %edx
801056a3:	ff 75 e4             	pushl  -0x1c(%ebp)
801056a6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801056a7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801056aa:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056ad:	56                   	push   %esi
801056ae:	ff 70 14             	pushl  0x14(%eax)
801056b1:	68 40 76 10 80       	push   $0x80107640
801056b6:	e8 f5 af ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801056bb:	83 c4 20             	add    $0x20,%esp
801056be:	e8 8d df ff ff       	call   80103650 <myproc>
801056c3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056ca:	e8 81 df ff ff       	call   80103650 <myproc>
801056cf:	85 c0                	test   %eax,%eax
801056d1:	74 1d                	je     801056f0 <trap+0xc0>
801056d3:	e8 78 df ff ff       	call   80103650 <myproc>
801056d8:	8b 50 28             	mov    0x28(%eax),%edx
801056db:	85 d2                	test   %edx,%edx
801056dd:	74 11                	je     801056f0 <trap+0xc0>
801056df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056e3:	83 e0 03             	and    $0x3,%eax
801056e6:	66 83 f8 03          	cmp    $0x3,%ax
801056ea:	0f 84 50 01 00 00    	je     80105840 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801056f0:	e8 5b df ff ff       	call   80103650 <myproc>
801056f5:	85 c0                	test   %eax,%eax
801056f7:	74 0f                	je     80105708 <trap+0xd8>
801056f9:	e8 52 df ff ff       	call   80103650 <myproc>
801056fe:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105702:	0f 84 e8 00 00 00    	je     801057f0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105708:	e8 43 df ff ff       	call   80103650 <myproc>
8010570d:	85 c0                	test   %eax,%eax
8010570f:	74 1d                	je     8010572e <trap+0xfe>
80105711:	e8 3a df ff ff       	call   80103650 <myproc>
80105716:	8b 40 28             	mov    0x28(%eax),%eax
80105719:	85 c0                	test   %eax,%eax
8010571b:	74 11                	je     8010572e <trap+0xfe>
8010571d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105721:	83 e0 03             	and    $0x3,%eax
80105724:	66 83 f8 03          	cmp    $0x3,%ax
80105728:	0f 84 03 01 00 00    	je     80105831 <trap+0x201>
    exit();
}
8010572e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105731:	5b                   	pop    %ebx
80105732:	5e                   	pop    %esi
80105733:	5f                   	pop    %edi
80105734:	5d                   	pop    %ebp
80105735:	c3                   	ret    
    ideintr();
80105736:	e8 a5 16 00 00       	call   80106de0 <ideintr>
    lapiceoi();
8010573b:	e8 70 ce ff ff       	call   801025b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105740:	e8 0b df ff ff       	call   80103650 <myproc>
80105745:	85 c0                	test   %eax,%eax
80105747:	75 8a                	jne    801056d3 <trap+0xa3>
80105749:	eb a5                	jmp    801056f0 <trap+0xc0>
    if(cpuid() == 0){
8010574b:	e8 e0 de ff ff       	call   80103630 <cpuid>
80105750:	85 c0                	test   %eax,%eax
80105752:	75 e7                	jne    8010573b <trap+0x10b>
      acquire(&tickslock);
80105754:	83 ec 0c             	sub    $0xc,%esp
80105757:	68 20 1d 19 80       	push   $0x80191d20
8010575c:	e8 9f ea ff ff       	call   80104200 <acquire>
      wakeup(&ticks);
80105761:	c7 04 24 60 25 19 80 	movl   $0x80192560,(%esp)
      ticks++;
80105768:	83 05 60 25 19 80 01 	addl   $0x1,0x80192560
      wakeup(&ticks);
8010576f:	e8 0c e6 ff ff       	call   80103d80 <wakeup>
      release(&tickslock);
80105774:	c7 04 24 20 1d 19 80 	movl   $0x80191d20,(%esp)
8010577b:	e8 40 eb ff ff       	call   801042c0 <release>
80105780:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105783:	eb b6                	jmp    8010573b <trap+0x10b>
    kbdintr();
80105785:	e8 e6 cc ff ff       	call   80102470 <kbdintr>
    lapiceoi();
8010578a:	e8 21 ce ff ff       	call   801025b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010578f:	e8 bc de ff ff       	call   80103650 <myproc>
80105794:	85 c0                	test   %eax,%eax
80105796:	0f 85 37 ff ff ff    	jne    801056d3 <trap+0xa3>
8010579c:	e9 4f ff ff ff       	jmp    801056f0 <trap+0xc0>
    uartintr();
801057a1:	e8 4a 02 00 00       	call   801059f0 <uartintr>
    lapiceoi();
801057a6:	e8 05 ce ff ff       	call   801025b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057ab:	e8 a0 de ff ff       	call   80103650 <myproc>
801057b0:	85 c0                	test   %eax,%eax
801057b2:	0f 85 1b ff ff ff    	jne    801056d3 <trap+0xa3>
801057b8:	e9 33 ff ff ff       	jmp    801056f0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801057bd:	8b 7b 38             	mov    0x38(%ebx),%edi
801057c0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801057c4:	e8 67 de ff ff       	call   80103630 <cpuid>
801057c9:	57                   	push   %edi
801057ca:	56                   	push   %esi
801057cb:	50                   	push   %eax
801057cc:	68 e8 75 10 80       	push   $0x801075e8
801057d1:	e8 da ae ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801057d6:	e8 d5 cd ff ff       	call   801025b0 <lapiceoi>
    break;
801057db:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057de:	e8 6d de ff ff       	call   80103650 <myproc>
801057e3:	85 c0                	test   %eax,%eax
801057e5:	0f 85 e8 fe ff ff    	jne    801056d3 <trap+0xa3>
801057eb:	e9 00 ff ff ff       	jmp    801056f0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801057f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801057f4:	0f 85 0e ff ff ff    	jne    80105708 <trap+0xd8>
    yield();
801057fa:	e8 91 e3 ff ff       	call   80103b90 <yield>
801057ff:	e9 04 ff ff ff       	jmp    80105708 <trap+0xd8>
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105808:	e8 43 de ff ff       	call   80103650 <myproc>
8010580d:	8b 70 28             	mov    0x28(%eax),%esi
80105810:	85 f6                	test   %esi,%esi
80105812:	75 3c                	jne    80105850 <trap+0x220>
    myproc()->tf = tf;
80105814:	e8 37 de ff ff       	call   80103650 <myproc>
80105819:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
8010581c:	e8 bf ee ff ff       	call   801046e0 <syscall>
    if(myproc()->killed)
80105821:	e8 2a de ff ff       	call   80103650 <myproc>
80105826:	8b 48 28             	mov    0x28(%eax),%ecx
80105829:	85 c9                	test   %ecx,%ecx
8010582b:	0f 84 fd fe ff ff    	je     8010572e <trap+0xfe>
}
80105831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
      exit();
80105838:	e9 23 e2 ff ff       	jmp    80103a60 <exit>
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105840:	e8 1b e2 ff ff       	call   80103a60 <exit>
80105845:	e9 a6 fe ff ff       	jmp    801056f0 <trap+0xc0>
8010584a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105850:	e8 0b e2 ff ff       	call   80103a60 <exit>
80105855:	eb bd                	jmp    80105814 <trap+0x1e4>
80105857:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010585a:	e8 d1 dd ff ff       	call   80103630 <cpuid>
8010585f:	83 ec 0c             	sub    $0xc,%esp
80105862:	56                   	push   %esi
80105863:	57                   	push   %edi
80105864:	50                   	push   %eax
80105865:	ff 73 30             	pushl  0x30(%ebx)
80105868:	68 0c 76 10 80       	push   $0x8010760c
8010586d:	e8 3e ae ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105872:	83 c4 14             	add    $0x14,%esp
80105875:	68 e2 75 10 80       	push   $0x801075e2
8010587a:	e8 11 ab ff ff       	call   80100390 <panic>
8010587f:	90                   	nop

80105880 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105880:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105884:	a1 64 75 18 80       	mov    0x80187564,%eax
80105889:	85 c0                	test   %eax,%eax
8010588b:	74 1b                	je     801058a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010588d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105892:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105893:	a8 01                	test   $0x1,%al
80105895:	74 11                	je     801058a8 <uartgetc+0x28>
80105897:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010589c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010589d:	0f b6 c0             	movzbl %al,%eax
801058a0:	c3                   	ret    
801058a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058ad:	c3                   	ret    
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <uartputc.part.0>:
uartputc(int c)
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	89 c7                	mov    %eax,%edi
801058b6:	56                   	push   %esi
801058b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801058bc:	53                   	push   %ebx
801058bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801058c2:	83 ec 0c             	sub    $0xc,%esp
801058c5:	eb 1b                	jmp    801058e2 <uartputc.part.0+0x32>
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	6a 0a                	push   $0xa
801058d5:	e8 f6 cc ff ff       	call   801025d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	83 eb 01             	sub    $0x1,%ebx
801058e0:	74 07                	je     801058e9 <uartputc.part.0+0x39>
801058e2:	89 f2                	mov    %esi,%edx
801058e4:	ec                   	in     (%dx),%al
801058e5:	a8 20                	test   $0x20,%al
801058e7:	74 e7                	je     801058d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058ee:	89 f8                	mov    %edi,%eax
801058f0:	ee                   	out    %al,(%dx)
}
801058f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058f4:	5b                   	pop    %ebx
801058f5:	5e                   	pop    %esi
801058f6:	5f                   	pop    %edi
801058f7:	5d                   	pop    %ebp
801058f8:	c3                   	ret    
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105900 <uartinit>:
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
80105905:	31 c9                	xor    %ecx,%ecx
80105907:	89 c8                	mov    %ecx,%eax
80105909:	89 e5                	mov    %esp,%ebp
8010590b:	57                   	push   %edi
8010590c:	56                   	push   %esi
8010590d:	53                   	push   %ebx
8010590e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105913:	89 da                	mov    %ebx,%edx
80105915:	83 ec 0c             	sub    $0xc,%esp
80105918:	ee                   	out    %al,(%dx)
80105919:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010591e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105923:	89 fa                	mov    %edi,%edx
80105925:	ee                   	out    %al,(%dx)
80105926:	b8 0c 00 00 00       	mov    $0xc,%eax
8010592b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105930:	ee                   	out    %al,(%dx)
80105931:	be f9 03 00 00       	mov    $0x3f9,%esi
80105936:	89 c8                	mov    %ecx,%eax
80105938:	89 f2                	mov    %esi,%edx
8010593a:	ee                   	out    %al,(%dx)
8010593b:	b8 03 00 00 00       	mov    $0x3,%eax
80105940:	89 fa                	mov    %edi,%edx
80105942:	ee                   	out    %al,(%dx)
80105943:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105948:	89 c8                	mov    %ecx,%eax
8010594a:	ee                   	out    %al,(%dx)
8010594b:	b8 01 00 00 00       	mov    $0x1,%eax
80105950:	89 f2                	mov    %esi,%edx
80105952:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105953:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105958:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105959:	3c ff                	cmp    $0xff,%al
8010595b:	74 52                	je     801059af <uartinit+0xaf>
  uart = 1;
8010595d:	c7 05 64 75 18 80 01 	movl   $0x1,0x80187564
80105964:	00 00 00 
80105967:	89 da                	mov    %ebx,%edx
80105969:	ec                   	in     (%dx),%al
8010596a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010596f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105970:	83 ec 08             	sub    $0x8,%esp
80105973:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105978:	bb 04 77 10 80       	mov    $0x80107704,%ebx
  ioapicenable(IRQ_COM1, 0);
8010597d:	6a 00                	push   $0x0
8010597f:	6a 04                	push   $0x4
80105981:	e8 9a c7 ff ff       	call   80102120 <ioapicenable>
80105986:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105989:	b8 78 00 00 00       	mov    $0x78,%eax
8010598e:	eb 04                	jmp    80105994 <uartinit+0x94>
80105990:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105994:	8b 15 64 75 18 80    	mov    0x80187564,%edx
8010599a:	85 d2                	test   %edx,%edx
8010599c:	74 08                	je     801059a6 <uartinit+0xa6>
    uartputc(*p);
8010599e:	0f be c0             	movsbl %al,%eax
801059a1:	e8 0a ff ff ff       	call   801058b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801059a6:	89 f0                	mov    %esi,%eax
801059a8:	83 c3 01             	add    $0x1,%ebx
801059ab:	84 c0                	test   %al,%al
801059ad:	75 e1                	jne    80105990 <uartinit+0x90>
}
801059af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b2:	5b                   	pop    %ebx
801059b3:	5e                   	pop    %esi
801059b4:	5f                   	pop    %edi
801059b5:	5d                   	pop    %ebp
801059b6:	c3                   	ret    
801059b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059be:	66 90                	xchg   %ax,%ax

801059c0 <uartputc>:
{
801059c0:	f3 0f 1e fb          	endbr32 
801059c4:	55                   	push   %ebp
  if(!uart)
801059c5:	8b 15 64 75 18 80    	mov    0x80187564,%edx
{
801059cb:	89 e5                	mov    %esp,%ebp
801059cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801059d0:	85 d2                	test   %edx,%edx
801059d2:	74 0c                	je     801059e0 <uartputc+0x20>
}
801059d4:	5d                   	pop    %ebp
801059d5:	e9 d6 fe ff ff       	jmp    801058b0 <uartputc.part.0>
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059e0:	5d                   	pop    %ebp
801059e1:	c3                   	ret    
801059e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059f0 <uartintr>:

void
uartintr(void)
{
801059f0:	f3 0f 1e fb          	endbr32 
801059f4:	55                   	push   %ebp
801059f5:	89 e5                	mov    %esp,%ebp
801059f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801059fa:	68 80 58 10 80       	push   $0x80105880
801059ff:	e8 5c ae ff ff       	call   80100860 <consoleintr>
}
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	c9                   	leave  
80105a08:	c3                   	ret    

80105a09 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a09:	6a 00                	push   $0x0
  pushl $0
80105a0b:	6a 00                	push   $0x0
  jmp alltraps
80105a0d:	e9 3c fb ff ff       	jmp    8010554e <alltraps>

80105a12 <vector1>:
.globl vector1
vector1:
  pushl $0
80105a12:	6a 00                	push   $0x0
  pushl $1
80105a14:	6a 01                	push   $0x1
  jmp alltraps
80105a16:	e9 33 fb ff ff       	jmp    8010554e <alltraps>

80105a1b <vector2>:
.globl vector2
vector2:
  pushl $0
80105a1b:	6a 00                	push   $0x0
  pushl $2
80105a1d:	6a 02                	push   $0x2
  jmp alltraps
80105a1f:	e9 2a fb ff ff       	jmp    8010554e <alltraps>

80105a24 <vector3>:
.globl vector3
vector3:
  pushl $0
80105a24:	6a 00                	push   $0x0
  pushl $3
80105a26:	6a 03                	push   $0x3
  jmp alltraps
80105a28:	e9 21 fb ff ff       	jmp    8010554e <alltraps>

80105a2d <vector4>:
.globl vector4
vector4:
  pushl $0
80105a2d:	6a 00                	push   $0x0
  pushl $4
80105a2f:	6a 04                	push   $0x4
  jmp alltraps
80105a31:	e9 18 fb ff ff       	jmp    8010554e <alltraps>

80105a36 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a36:	6a 00                	push   $0x0
  pushl $5
80105a38:	6a 05                	push   $0x5
  jmp alltraps
80105a3a:	e9 0f fb ff ff       	jmp    8010554e <alltraps>

80105a3f <vector6>:
.globl vector6
vector6:
  pushl $0
80105a3f:	6a 00                	push   $0x0
  pushl $6
80105a41:	6a 06                	push   $0x6
  jmp alltraps
80105a43:	e9 06 fb ff ff       	jmp    8010554e <alltraps>

80105a48 <vector7>:
.globl vector7
vector7:
  pushl $0
80105a48:	6a 00                	push   $0x0
  pushl $7
80105a4a:	6a 07                	push   $0x7
  jmp alltraps
80105a4c:	e9 fd fa ff ff       	jmp    8010554e <alltraps>

80105a51 <vector8>:
.globl vector8
vector8:
  pushl $8
80105a51:	6a 08                	push   $0x8
  jmp alltraps
80105a53:	e9 f6 fa ff ff       	jmp    8010554e <alltraps>

80105a58 <vector9>:
.globl vector9
vector9:
  pushl $0
80105a58:	6a 00                	push   $0x0
  pushl $9
80105a5a:	6a 09                	push   $0x9
  jmp alltraps
80105a5c:	e9 ed fa ff ff       	jmp    8010554e <alltraps>

80105a61 <vector10>:
.globl vector10
vector10:
  pushl $10
80105a61:	6a 0a                	push   $0xa
  jmp alltraps
80105a63:	e9 e6 fa ff ff       	jmp    8010554e <alltraps>

80105a68 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a68:	6a 0b                	push   $0xb
  jmp alltraps
80105a6a:	e9 df fa ff ff       	jmp    8010554e <alltraps>

80105a6f <vector12>:
.globl vector12
vector12:
  pushl $12
80105a6f:	6a 0c                	push   $0xc
  jmp alltraps
80105a71:	e9 d8 fa ff ff       	jmp    8010554e <alltraps>

80105a76 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a76:	6a 0d                	push   $0xd
  jmp alltraps
80105a78:	e9 d1 fa ff ff       	jmp    8010554e <alltraps>

80105a7d <vector14>:
.globl vector14
vector14:
  pushl $14
80105a7d:	6a 0e                	push   $0xe
  jmp alltraps
80105a7f:	e9 ca fa ff ff       	jmp    8010554e <alltraps>

80105a84 <vector15>:
.globl vector15
vector15:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $15
80105a86:	6a 0f                	push   $0xf
  jmp alltraps
80105a88:	e9 c1 fa ff ff       	jmp    8010554e <alltraps>

80105a8d <vector16>:
.globl vector16
vector16:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $16
80105a8f:	6a 10                	push   $0x10
  jmp alltraps
80105a91:	e9 b8 fa ff ff       	jmp    8010554e <alltraps>

80105a96 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a96:	6a 11                	push   $0x11
  jmp alltraps
80105a98:	e9 b1 fa ff ff       	jmp    8010554e <alltraps>

80105a9d <vector18>:
.globl vector18
vector18:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $18
80105a9f:	6a 12                	push   $0x12
  jmp alltraps
80105aa1:	e9 a8 fa ff ff       	jmp    8010554e <alltraps>

80105aa6 <vector19>:
.globl vector19
vector19:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $19
80105aa8:	6a 13                	push   $0x13
  jmp alltraps
80105aaa:	e9 9f fa ff ff       	jmp    8010554e <alltraps>

80105aaf <vector20>:
.globl vector20
vector20:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $20
80105ab1:	6a 14                	push   $0x14
  jmp alltraps
80105ab3:	e9 96 fa ff ff       	jmp    8010554e <alltraps>

80105ab8 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $21
80105aba:	6a 15                	push   $0x15
  jmp alltraps
80105abc:	e9 8d fa ff ff       	jmp    8010554e <alltraps>

80105ac1 <vector22>:
.globl vector22
vector22:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $22
80105ac3:	6a 16                	push   $0x16
  jmp alltraps
80105ac5:	e9 84 fa ff ff       	jmp    8010554e <alltraps>

80105aca <vector23>:
.globl vector23
vector23:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $23
80105acc:	6a 17                	push   $0x17
  jmp alltraps
80105ace:	e9 7b fa ff ff       	jmp    8010554e <alltraps>

80105ad3 <vector24>:
.globl vector24
vector24:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $24
80105ad5:	6a 18                	push   $0x18
  jmp alltraps
80105ad7:	e9 72 fa ff ff       	jmp    8010554e <alltraps>

80105adc <vector25>:
.globl vector25
vector25:
  pushl $0
80105adc:	6a 00                	push   $0x0
  pushl $25
80105ade:	6a 19                	push   $0x19
  jmp alltraps
80105ae0:	e9 69 fa ff ff       	jmp    8010554e <alltraps>

80105ae5 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $26
80105ae7:	6a 1a                	push   $0x1a
  jmp alltraps
80105ae9:	e9 60 fa ff ff       	jmp    8010554e <alltraps>

80105aee <vector27>:
.globl vector27
vector27:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $27
80105af0:	6a 1b                	push   $0x1b
  jmp alltraps
80105af2:	e9 57 fa ff ff       	jmp    8010554e <alltraps>

80105af7 <vector28>:
.globl vector28
vector28:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $28
80105af9:	6a 1c                	push   $0x1c
  jmp alltraps
80105afb:	e9 4e fa ff ff       	jmp    8010554e <alltraps>

80105b00 <vector29>:
.globl vector29
vector29:
  pushl $0
80105b00:	6a 00                	push   $0x0
  pushl $29
80105b02:	6a 1d                	push   $0x1d
  jmp alltraps
80105b04:	e9 45 fa ff ff       	jmp    8010554e <alltraps>

80105b09 <vector30>:
.globl vector30
vector30:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $30
80105b0b:	6a 1e                	push   $0x1e
  jmp alltraps
80105b0d:	e9 3c fa ff ff       	jmp    8010554e <alltraps>

80105b12 <vector31>:
.globl vector31
vector31:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $31
80105b14:	6a 1f                	push   $0x1f
  jmp alltraps
80105b16:	e9 33 fa ff ff       	jmp    8010554e <alltraps>

80105b1b <vector32>:
.globl vector32
vector32:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $32
80105b1d:	6a 20                	push   $0x20
  jmp alltraps
80105b1f:	e9 2a fa ff ff       	jmp    8010554e <alltraps>

80105b24 <vector33>:
.globl vector33
vector33:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $33
80105b26:	6a 21                	push   $0x21
  jmp alltraps
80105b28:	e9 21 fa ff ff       	jmp    8010554e <alltraps>

80105b2d <vector34>:
.globl vector34
vector34:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $34
80105b2f:	6a 22                	push   $0x22
  jmp alltraps
80105b31:	e9 18 fa ff ff       	jmp    8010554e <alltraps>

80105b36 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $35
80105b38:	6a 23                	push   $0x23
  jmp alltraps
80105b3a:	e9 0f fa ff ff       	jmp    8010554e <alltraps>

80105b3f <vector36>:
.globl vector36
vector36:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $36
80105b41:	6a 24                	push   $0x24
  jmp alltraps
80105b43:	e9 06 fa ff ff       	jmp    8010554e <alltraps>

80105b48 <vector37>:
.globl vector37
vector37:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $37
80105b4a:	6a 25                	push   $0x25
  jmp alltraps
80105b4c:	e9 fd f9 ff ff       	jmp    8010554e <alltraps>

80105b51 <vector38>:
.globl vector38
vector38:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $38
80105b53:	6a 26                	push   $0x26
  jmp alltraps
80105b55:	e9 f4 f9 ff ff       	jmp    8010554e <alltraps>

80105b5a <vector39>:
.globl vector39
vector39:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $39
80105b5c:	6a 27                	push   $0x27
  jmp alltraps
80105b5e:	e9 eb f9 ff ff       	jmp    8010554e <alltraps>

80105b63 <vector40>:
.globl vector40
vector40:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $40
80105b65:	6a 28                	push   $0x28
  jmp alltraps
80105b67:	e9 e2 f9 ff ff       	jmp    8010554e <alltraps>

80105b6c <vector41>:
.globl vector41
vector41:
  pushl $0
80105b6c:	6a 00                	push   $0x0
  pushl $41
80105b6e:	6a 29                	push   $0x29
  jmp alltraps
80105b70:	e9 d9 f9 ff ff       	jmp    8010554e <alltraps>

80105b75 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $42
80105b77:	6a 2a                	push   $0x2a
  jmp alltraps
80105b79:	e9 d0 f9 ff ff       	jmp    8010554e <alltraps>

80105b7e <vector43>:
.globl vector43
vector43:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $43
80105b80:	6a 2b                	push   $0x2b
  jmp alltraps
80105b82:	e9 c7 f9 ff ff       	jmp    8010554e <alltraps>

80105b87 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $44
80105b89:	6a 2c                	push   $0x2c
  jmp alltraps
80105b8b:	e9 be f9 ff ff       	jmp    8010554e <alltraps>

80105b90 <vector45>:
.globl vector45
vector45:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $45
80105b92:	6a 2d                	push   $0x2d
  jmp alltraps
80105b94:	e9 b5 f9 ff ff       	jmp    8010554e <alltraps>

80105b99 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $46
80105b9b:	6a 2e                	push   $0x2e
  jmp alltraps
80105b9d:	e9 ac f9 ff ff       	jmp    8010554e <alltraps>

80105ba2 <vector47>:
.globl vector47
vector47:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $47
80105ba4:	6a 2f                	push   $0x2f
  jmp alltraps
80105ba6:	e9 a3 f9 ff ff       	jmp    8010554e <alltraps>

80105bab <vector48>:
.globl vector48
vector48:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $48
80105bad:	6a 30                	push   $0x30
  jmp alltraps
80105baf:	e9 9a f9 ff ff       	jmp    8010554e <alltraps>

80105bb4 <vector49>:
.globl vector49
vector49:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $49
80105bb6:	6a 31                	push   $0x31
  jmp alltraps
80105bb8:	e9 91 f9 ff ff       	jmp    8010554e <alltraps>

80105bbd <vector50>:
.globl vector50
vector50:
  pushl $0
80105bbd:	6a 00                	push   $0x0
  pushl $50
80105bbf:	6a 32                	push   $0x32
  jmp alltraps
80105bc1:	e9 88 f9 ff ff       	jmp    8010554e <alltraps>

80105bc6 <vector51>:
.globl vector51
vector51:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $51
80105bc8:	6a 33                	push   $0x33
  jmp alltraps
80105bca:	e9 7f f9 ff ff       	jmp    8010554e <alltraps>

80105bcf <vector52>:
.globl vector52
vector52:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $52
80105bd1:	6a 34                	push   $0x34
  jmp alltraps
80105bd3:	e9 76 f9 ff ff       	jmp    8010554e <alltraps>

80105bd8 <vector53>:
.globl vector53
vector53:
  pushl $0
80105bd8:	6a 00                	push   $0x0
  pushl $53
80105bda:	6a 35                	push   $0x35
  jmp alltraps
80105bdc:	e9 6d f9 ff ff       	jmp    8010554e <alltraps>

80105be1 <vector54>:
.globl vector54
vector54:
  pushl $0
80105be1:	6a 00                	push   $0x0
  pushl $54
80105be3:	6a 36                	push   $0x36
  jmp alltraps
80105be5:	e9 64 f9 ff ff       	jmp    8010554e <alltraps>

80105bea <vector55>:
.globl vector55
vector55:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $55
80105bec:	6a 37                	push   $0x37
  jmp alltraps
80105bee:	e9 5b f9 ff ff       	jmp    8010554e <alltraps>

80105bf3 <vector56>:
.globl vector56
vector56:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $56
80105bf5:	6a 38                	push   $0x38
  jmp alltraps
80105bf7:	e9 52 f9 ff ff       	jmp    8010554e <alltraps>

80105bfc <vector57>:
.globl vector57
vector57:
  pushl $0
80105bfc:	6a 00                	push   $0x0
  pushl $57
80105bfe:	6a 39                	push   $0x39
  jmp alltraps
80105c00:	e9 49 f9 ff ff       	jmp    8010554e <alltraps>

80105c05 <vector58>:
.globl vector58
vector58:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $58
80105c07:	6a 3a                	push   $0x3a
  jmp alltraps
80105c09:	e9 40 f9 ff ff       	jmp    8010554e <alltraps>

80105c0e <vector59>:
.globl vector59
vector59:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $59
80105c10:	6a 3b                	push   $0x3b
  jmp alltraps
80105c12:	e9 37 f9 ff ff       	jmp    8010554e <alltraps>

80105c17 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $60
80105c19:	6a 3c                	push   $0x3c
  jmp alltraps
80105c1b:	e9 2e f9 ff ff       	jmp    8010554e <alltraps>

80105c20 <vector61>:
.globl vector61
vector61:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $61
80105c22:	6a 3d                	push   $0x3d
  jmp alltraps
80105c24:	e9 25 f9 ff ff       	jmp    8010554e <alltraps>

80105c29 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $62
80105c2b:	6a 3e                	push   $0x3e
  jmp alltraps
80105c2d:	e9 1c f9 ff ff       	jmp    8010554e <alltraps>

80105c32 <vector63>:
.globl vector63
vector63:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $63
80105c34:	6a 3f                	push   $0x3f
  jmp alltraps
80105c36:	e9 13 f9 ff ff       	jmp    8010554e <alltraps>

80105c3b <vector64>:
.globl vector64
vector64:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $64
80105c3d:	6a 40                	push   $0x40
  jmp alltraps
80105c3f:	e9 0a f9 ff ff       	jmp    8010554e <alltraps>

80105c44 <vector65>:
.globl vector65
vector65:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $65
80105c46:	6a 41                	push   $0x41
  jmp alltraps
80105c48:	e9 01 f9 ff ff       	jmp    8010554e <alltraps>

80105c4d <vector66>:
.globl vector66
vector66:
  pushl $0
80105c4d:	6a 00                	push   $0x0
  pushl $66
80105c4f:	6a 42                	push   $0x42
  jmp alltraps
80105c51:	e9 f8 f8 ff ff       	jmp    8010554e <alltraps>

80105c56 <vector67>:
.globl vector67
vector67:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $67
80105c58:	6a 43                	push   $0x43
  jmp alltraps
80105c5a:	e9 ef f8 ff ff       	jmp    8010554e <alltraps>

80105c5f <vector68>:
.globl vector68
vector68:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $68
80105c61:	6a 44                	push   $0x44
  jmp alltraps
80105c63:	e9 e6 f8 ff ff       	jmp    8010554e <alltraps>

80105c68 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c68:	6a 00                	push   $0x0
  pushl $69
80105c6a:	6a 45                	push   $0x45
  jmp alltraps
80105c6c:	e9 dd f8 ff ff       	jmp    8010554e <alltraps>

80105c71 <vector70>:
.globl vector70
vector70:
  pushl $0
80105c71:	6a 00                	push   $0x0
  pushl $70
80105c73:	6a 46                	push   $0x46
  jmp alltraps
80105c75:	e9 d4 f8 ff ff       	jmp    8010554e <alltraps>

80105c7a <vector71>:
.globl vector71
vector71:
  pushl $0
80105c7a:	6a 00                	push   $0x0
  pushl $71
80105c7c:	6a 47                	push   $0x47
  jmp alltraps
80105c7e:	e9 cb f8 ff ff       	jmp    8010554e <alltraps>

80105c83 <vector72>:
.globl vector72
vector72:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $72
80105c85:	6a 48                	push   $0x48
  jmp alltraps
80105c87:	e9 c2 f8 ff ff       	jmp    8010554e <alltraps>

80105c8c <vector73>:
.globl vector73
vector73:
  pushl $0
80105c8c:	6a 00                	push   $0x0
  pushl $73
80105c8e:	6a 49                	push   $0x49
  jmp alltraps
80105c90:	e9 b9 f8 ff ff       	jmp    8010554e <alltraps>

80105c95 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $74
80105c97:	6a 4a                	push   $0x4a
  jmp alltraps
80105c99:	e9 b0 f8 ff ff       	jmp    8010554e <alltraps>

80105c9e <vector75>:
.globl vector75
vector75:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $75
80105ca0:	6a 4b                	push   $0x4b
  jmp alltraps
80105ca2:	e9 a7 f8 ff ff       	jmp    8010554e <alltraps>

80105ca7 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $76
80105ca9:	6a 4c                	push   $0x4c
  jmp alltraps
80105cab:	e9 9e f8 ff ff       	jmp    8010554e <alltraps>

80105cb0 <vector77>:
.globl vector77
vector77:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $77
80105cb2:	6a 4d                	push   $0x4d
  jmp alltraps
80105cb4:	e9 95 f8 ff ff       	jmp    8010554e <alltraps>

80105cb9 <vector78>:
.globl vector78
vector78:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $78
80105cbb:	6a 4e                	push   $0x4e
  jmp alltraps
80105cbd:	e9 8c f8 ff ff       	jmp    8010554e <alltraps>

80105cc2 <vector79>:
.globl vector79
vector79:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $79
80105cc4:	6a 4f                	push   $0x4f
  jmp alltraps
80105cc6:	e9 83 f8 ff ff       	jmp    8010554e <alltraps>

80105ccb <vector80>:
.globl vector80
vector80:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $80
80105ccd:	6a 50                	push   $0x50
  jmp alltraps
80105ccf:	e9 7a f8 ff ff       	jmp    8010554e <alltraps>

80105cd4 <vector81>:
.globl vector81
vector81:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $81
80105cd6:	6a 51                	push   $0x51
  jmp alltraps
80105cd8:	e9 71 f8 ff ff       	jmp    8010554e <alltraps>

80105cdd <vector82>:
.globl vector82
vector82:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $82
80105cdf:	6a 52                	push   $0x52
  jmp alltraps
80105ce1:	e9 68 f8 ff ff       	jmp    8010554e <alltraps>

80105ce6 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $83
80105ce8:	6a 53                	push   $0x53
  jmp alltraps
80105cea:	e9 5f f8 ff ff       	jmp    8010554e <alltraps>

80105cef <vector84>:
.globl vector84
vector84:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $84
80105cf1:	6a 54                	push   $0x54
  jmp alltraps
80105cf3:	e9 56 f8 ff ff       	jmp    8010554e <alltraps>

80105cf8 <vector85>:
.globl vector85
vector85:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $85
80105cfa:	6a 55                	push   $0x55
  jmp alltraps
80105cfc:	e9 4d f8 ff ff       	jmp    8010554e <alltraps>

80105d01 <vector86>:
.globl vector86
vector86:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $86
80105d03:	6a 56                	push   $0x56
  jmp alltraps
80105d05:	e9 44 f8 ff ff       	jmp    8010554e <alltraps>

80105d0a <vector87>:
.globl vector87
vector87:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $87
80105d0c:	6a 57                	push   $0x57
  jmp alltraps
80105d0e:	e9 3b f8 ff ff       	jmp    8010554e <alltraps>

80105d13 <vector88>:
.globl vector88
vector88:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $88
80105d15:	6a 58                	push   $0x58
  jmp alltraps
80105d17:	e9 32 f8 ff ff       	jmp    8010554e <alltraps>

80105d1c <vector89>:
.globl vector89
vector89:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $89
80105d1e:	6a 59                	push   $0x59
  jmp alltraps
80105d20:	e9 29 f8 ff ff       	jmp    8010554e <alltraps>

80105d25 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $90
80105d27:	6a 5a                	push   $0x5a
  jmp alltraps
80105d29:	e9 20 f8 ff ff       	jmp    8010554e <alltraps>

80105d2e <vector91>:
.globl vector91
vector91:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $91
80105d30:	6a 5b                	push   $0x5b
  jmp alltraps
80105d32:	e9 17 f8 ff ff       	jmp    8010554e <alltraps>

80105d37 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $92
80105d39:	6a 5c                	push   $0x5c
  jmp alltraps
80105d3b:	e9 0e f8 ff ff       	jmp    8010554e <alltraps>

80105d40 <vector93>:
.globl vector93
vector93:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $93
80105d42:	6a 5d                	push   $0x5d
  jmp alltraps
80105d44:	e9 05 f8 ff ff       	jmp    8010554e <alltraps>

80105d49 <vector94>:
.globl vector94
vector94:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $94
80105d4b:	6a 5e                	push   $0x5e
  jmp alltraps
80105d4d:	e9 fc f7 ff ff       	jmp    8010554e <alltraps>

80105d52 <vector95>:
.globl vector95
vector95:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $95
80105d54:	6a 5f                	push   $0x5f
  jmp alltraps
80105d56:	e9 f3 f7 ff ff       	jmp    8010554e <alltraps>

80105d5b <vector96>:
.globl vector96
vector96:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $96
80105d5d:	6a 60                	push   $0x60
  jmp alltraps
80105d5f:	e9 ea f7 ff ff       	jmp    8010554e <alltraps>

80105d64 <vector97>:
.globl vector97
vector97:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $97
80105d66:	6a 61                	push   $0x61
  jmp alltraps
80105d68:	e9 e1 f7 ff ff       	jmp    8010554e <alltraps>

80105d6d <vector98>:
.globl vector98
vector98:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $98
80105d6f:	6a 62                	push   $0x62
  jmp alltraps
80105d71:	e9 d8 f7 ff ff       	jmp    8010554e <alltraps>

80105d76 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $99
80105d78:	6a 63                	push   $0x63
  jmp alltraps
80105d7a:	e9 cf f7 ff ff       	jmp    8010554e <alltraps>

80105d7f <vector100>:
.globl vector100
vector100:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $100
80105d81:	6a 64                	push   $0x64
  jmp alltraps
80105d83:	e9 c6 f7 ff ff       	jmp    8010554e <alltraps>

80105d88 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $101
80105d8a:	6a 65                	push   $0x65
  jmp alltraps
80105d8c:	e9 bd f7 ff ff       	jmp    8010554e <alltraps>

80105d91 <vector102>:
.globl vector102
vector102:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $102
80105d93:	6a 66                	push   $0x66
  jmp alltraps
80105d95:	e9 b4 f7 ff ff       	jmp    8010554e <alltraps>

80105d9a <vector103>:
.globl vector103
vector103:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $103
80105d9c:	6a 67                	push   $0x67
  jmp alltraps
80105d9e:	e9 ab f7 ff ff       	jmp    8010554e <alltraps>

80105da3 <vector104>:
.globl vector104
vector104:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $104
80105da5:	6a 68                	push   $0x68
  jmp alltraps
80105da7:	e9 a2 f7 ff ff       	jmp    8010554e <alltraps>

80105dac <vector105>:
.globl vector105
vector105:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $105
80105dae:	6a 69                	push   $0x69
  jmp alltraps
80105db0:	e9 99 f7 ff ff       	jmp    8010554e <alltraps>

80105db5 <vector106>:
.globl vector106
vector106:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $106
80105db7:	6a 6a                	push   $0x6a
  jmp alltraps
80105db9:	e9 90 f7 ff ff       	jmp    8010554e <alltraps>

80105dbe <vector107>:
.globl vector107
vector107:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $107
80105dc0:	6a 6b                	push   $0x6b
  jmp alltraps
80105dc2:	e9 87 f7 ff ff       	jmp    8010554e <alltraps>

80105dc7 <vector108>:
.globl vector108
vector108:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $108
80105dc9:	6a 6c                	push   $0x6c
  jmp alltraps
80105dcb:	e9 7e f7 ff ff       	jmp    8010554e <alltraps>

80105dd0 <vector109>:
.globl vector109
vector109:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $109
80105dd2:	6a 6d                	push   $0x6d
  jmp alltraps
80105dd4:	e9 75 f7 ff ff       	jmp    8010554e <alltraps>

80105dd9 <vector110>:
.globl vector110
vector110:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $110
80105ddb:	6a 6e                	push   $0x6e
  jmp alltraps
80105ddd:	e9 6c f7 ff ff       	jmp    8010554e <alltraps>

80105de2 <vector111>:
.globl vector111
vector111:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $111
80105de4:	6a 6f                	push   $0x6f
  jmp alltraps
80105de6:	e9 63 f7 ff ff       	jmp    8010554e <alltraps>

80105deb <vector112>:
.globl vector112
vector112:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $112
80105ded:	6a 70                	push   $0x70
  jmp alltraps
80105def:	e9 5a f7 ff ff       	jmp    8010554e <alltraps>

80105df4 <vector113>:
.globl vector113
vector113:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $113
80105df6:	6a 71                	push   $0x71
  jmp alltraps
80105df8:	e9 51 f7 ff ff       	jmp    8010554e <alltraps>

80105dfd <vector114>:
.globl vector114
vector114:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $114
80105dff:	6a 72                	push   $0x72
  jmp alltraps
80105e01:	e9 48 f7 ff ff       	jmp    8010554e <alltraps>

80105e06 <vector115>:
.globl vector115
vector115:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $115
80105e08:	6a 73                	push   $0x73
  jmp alltraps
80105e0a:	e9 3f f7 ff ff       	jmp    8010554e <alltraps>

80105e0f <vector116>:
.globl vector116
vector116:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $116
80105e11:	6a 74                	push   $0x74
  jmp alltraps
80105e13:	e9 36 f7 ff ff       	jmp    8010554e <alltraps>

80105e18 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $117
80105e1a:	6a 75                	push   $0x75
  jmp alltraps
80105e1c:	e9 2d f7 ff ff       	jmp    8010554e <alltraps>

80105e21 <vector118>:
.globl vector118
vector118:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $118
80105e23:	6a 76                	push   $0x76
  jmp alltraps
80105e25:	e9 24 f7 ff ff       	jmp    8010554e <alltraps>

80105e2a <vector119>:
.globl vector119
vector119:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $119
80105e2c:	6a 77                	push   $0x77
  jmp alltraps
80105e2e:	e9 1b f7 ff ff       	jmp    8010554e <alltraps>

80105e33 <vector120>:
.globl vector120
vector120:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $120
80105e35:	6a 78                	push   $0x78
  jmp alltraps
80105e37:	e9 12 f7 ff ff       	jmp    8010554e <alltraps>

80105e3c <vector121>:
.globl vector121
vector121:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $121
80105e3e:	6a 79                	push   $0x79
  jmp alltraps
80105e40:	e9 09 f7 ff ff       	jmp    8010554e <alltraps>

80105e45 <vector122>:
.globl vector122
vector122:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $122
80105e47:	6a 7a                	push   $0x7a
  jmp alltraps
80105e49:	e9 00 f7 ff ff       	jmp    8010554e <alltraps>

80105e4e <vector123>:
.globl vector123
vector123:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $123
80105e50:	6a 7b                	push   $0x7b
  jmp alltraps
80105e52:	e9 f7 f6 ff ff       	jmp    8010554e <alltraps>

80105e57 <vector124>:
.globl vector124
vector124:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $124
80105e59:	6a 7c                	push   $0x7c
  jmp alltraps
80105e5b:	e9 ee f6 ff ff       	jmp    8010554e <alltraps>

80105e60 <vector125>:
.globl vector125
vector125:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $125
80105e62:	6a 7d                	push   $0x7d
  jmp alltraps
80105e64:	e9 e5 f6 ff ff       	jmp    8010554e <alltraps>

80105e69 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $126
80105e6b:	6a 7e                	push   $0x7e
  jmp alltraps
80105e6d:	e9 dc f6 ff ff       	jmp    8010554e <alltraps>

80105e72 <vector127>:
.globl vector127
vector127:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $127
80105e74:	6a 7f                	push   $0x7f
  jmp alltraps
80105e76:	e9 d3 f6 ff ff       	jmp    8010554e <alltraps>

80105e7b <vector128>:
.globl vector128
vector128:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $128
80105e7d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e82:	e9 c7 f6 ff ff       	jmp    8010554e <alltraps>

80105e87 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $129
80105e89:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e8e:	e9 bb f6 ff ff       	jmp    8010554e <alltraps>

80105e93 <vector130>:
.globl vector130
vector130:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $130
80105e95:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e9a:	e9 af f6 ff ff       	jmp    8010554e <alltraps>

80105e9f <vector131>:
.globl vector131
vector131:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $131
80105ea1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105ea6:	e9 a3 f6 ff ff       	jmp    8010554e <alltraps>

80105eab <vector132>:
.globl vector132
vector132:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $132
80105ead:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105eb2:	e9 97 f6 ff ff       	jmp    8010554e <alltraps>

80105eb7 <vector133>:
.globl vector133
vector133:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $133
80105eb9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105ebe:	e9 8b f6 ff ff       	jmp    8010554e <alltraps>

80105ec3 <vector134>:
.globl vector134
vector134:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $134
80105ec5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105eca:	e9 7f f6 ff ff       	jmp    8010554e <alltraps>

80105ecf <vector135>:
.globl vector135
vector135:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $135
80105ed1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105ed6:	e9 73 f6 ff ff       	jmp    8010554e <alltraps>

80105edb <vector136>:
.globl vector136
vector136:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $136
80105edd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105ee2:	e9 67 f6 ff ff       	jmp    8010554e <alltraps>

80105ee7 <vector137>:
.globl vector137
vector137:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $137
80105ee9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105eee:	e9 5b f6 ff ff       	jmp    8010554e <alltraps>

80105ef3 <vector138>:
.globl vector138
vector138:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $138
80105ef5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105efa:	e9 4f f6 ff ff       	jmp    8010554e <alltraps>

80105eff <vector139>:
.globl vector139
vector139:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $139
80105f01:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f06:	e9 43 f6 ff ff       	jmp    8010554e <alltraps>

80105f0b <vector140>:
.globl vector140
vector140:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $140
80105f0d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f12:	e9 37 f6 ff ff       	jmp    8010554e <alltraps>

80105f17 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $141
80105f19:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f1e:	e9 2b f6 ff ff       	jmp    8010554e <alltraps>

80105f23 <vector142>:
.globl vector142
vector142:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $142
80105f25:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f2a:	e9 1f f6 ff ff       	jmp    8010554e <alltraps>

80105f2f <vector143>:
.globl vector143
vector143:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $143
80105f31:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f36:	e9 13 f6 ff ff       	jmp    8010554e <alltraps>

80105f3b <vector144>:
.globl vector144
vector144:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $144
80105f3d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f42:	e9 07 f6 ff ff       	jmp    8010554e <alltraps>

80105f47 <vector145>:
.globl vector145
vector145:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $145
80105f49:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f4e:	e9 fb f5 ff ff       	jmp    8010554e <alltraps>

80105f53 <vector146>:
.globl vector146
vector146:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $146
80105f55:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f5a:	e9 ef f5 ff ff       	jmp    8010554e <alltraps>

80105f5f <vector147>:
.globl vector147
vector147:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $147
80105f61:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f66:	e9 e3 f5 ff ff       	jmp    8010554e <alltraps>

80105f6b <vector148>:
.globl vector148
vector148:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $148
80105f6d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f72:	e9 d7 f5 ff ff       	jmp    8010554e <alltraps>

80105f77 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $149
80105f79:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f7e:	e9 cb f5 ff ff       	jmp    8010554e <alltraps>

80105f83 <vector150>:
.globl vector150
vector150:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $150
80105f85:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f8a:	e9 bf f5 ff ff       	jmp    8010554e <alltraps>

80105f8f <vector151>:
.globl vector151
vector151:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $151
80105f91:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f96:	e9 b3 f5 ff ff       	jmp    8010554e <alltraps>

80105f9b <vector152>:
.globl vector152
vector152:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $152
80105f9d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105fa2:	e9 a7 f5 ff ff       	jmp    8010554e <alltraps>

80105fa7 <vector153>:
.globl vector153
vector153:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $153
80105fa9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105fae:	e9 9b f5 ff ff       	jmp    8010554e <alltraps>

80105fb3 <vector154>:
.globl vector154
vector154:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $154
80105fb5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105fba:	e9 8f f5 ff ff       	jmp    8010554e <alltraps>

80105fbf <vector155>:
.globl vector155
vector155:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $155
80105fc1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105fc6:	e9 83 f5 ff ff       	jmp    8010554e <alltraps>

80105fcb <vector156>:
.globl vector156
vector156:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $156
80105fcd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105fd2:	e9 77 f5 ff ff       	jmp    8010554e <alltraps>

80105fd7 <vector157>:
.globl vector157
vector157:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $157
80105fd9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105fde:	e9 6b f5 ff ff       	jmp    8010554e <alltraps>

80105fe3 <vector158>:
.globl vector158
vector158:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $158
80105fe5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105fea:	e9 5f f5 ff ff       	jmp    8010554e <alltraps>

80105fef <vector159>:
.globl vector159
vector159:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $159
80105ff1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ff6:	e9 53 f5 ff ff       	jmp    8010554e <alltraps>

80105ffb <vector160>:
.globl vector160
vector160:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $160
80105ffd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106002:	e9 47 f5 ff ff       	jmp    8010554e <alltraps>

80106007 <vector161>:
.globl vector161
vector161:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $161
80106009:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010600e:	e9 3b f5 ff ff       	jmp    8010554e <alltraps>

80106013 <vector162>:
.globl vector162
vector162:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $162
80106015:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010601a:	e9 2f f5 ff ff       	jmp    8010554e <alltraps>

8010601f <vector163>:
.globl vector163
vector163:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $163
80106021:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106026:	e9 23 f5 ff ff       	jmp    8010554e <alltraps>

8010602b <vector164>:
.globl vector164
vector164:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $164
8010602d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106032:	e9 17 f5 ff ff       	jmp    8010554e <alltraps>

80106037 <vector165>:
.globl vector165
vector165:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $165
80106039:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010603e:	e9 0b f5 ff ff       	jmp    8010554e <alltraps>

80106043 <vector166>:
.globl vector166
vector166:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $166
80106045:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010604a:	e9 ff f4 ff ff       	jmp    8010554e <alltraps>

8010604f <vector167>:
.globl vector167
vector167:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $167
80106051:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106056:	e9 f3 f4 ff ff       	jmp    8010554e <alltraps>

8010605b <vector168>:
.globl vector168
vector168:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $168
8010605d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106062:	e9 e7 f4 ff ff       	jmp    8010554e <alltraps>

80106067 <vector169>:
.globl vector169
vector169:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $169
80106069:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010606e:	e9 db f4 ff ff       	jmp    8010554e <alltraps>

80106073 <vector170>:
.globl vector170
vector170:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $170
80106075:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010607a:	e9 cf f4 ff ff       	jmp    8010554e <alltraps>

8010607f <vector171>:
.globl vector171
vector171:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $171
80106081:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106086:	e9 c3 f4 ff ff       	jmp    8010554e <alltraps>

8010608b <vector172>:
.globl vector172
vector172:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $172
8010608d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106092:	e9 b7 f4 ff ff       	jmp    8010554e <alltraps>

80106097 <vector173>:
.globl vector173
vector173:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $173
80106099:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010609e:	e9 ab f4 ff ff       	jmp    8010554e <alltraps>

801060a3 <vector174>:
.globl vector174
vector174:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $174
801060a5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801060aa:	e9 9f f4 ff ff       	jmp    8010554e <alltraps>

801060af <vector175>:
.globl vector175
vector175:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $175
801060b1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801060b6:	e9 93 f4 ff ff       	jmp    8010554e <alltraps>

801060bb <vector176>:
.globl vector176
vector176:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $176
801060bd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801060c2:	e9 87 f4 ff ff       	jmp    8010554e <alltraps>

801060c7 <vector177>:
.globl vector177
vector177:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $177
801060c9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060ce:	e9 7b f4 ff ff       	jmp    8010554e <alltraps>

801060d3 <vector178>:
.globl vector178
vector178:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $178
801060d5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801060da:	e9 6f f4 ff ff       	jmp    8010554e <alltraps>

801060df <vector179>:
.globl vector179
vector179:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $179
801060e1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801060e6:	e9 63 f4 ff ff       	jmp    8010554e <alltraps>

801060eb <vector180>:
.globl vector180
vector180:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $180
801060ed:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801060f2:	e9 57 f4 ff ff       	jmp    8010554e <alltraps>

801060f7 <vector181>:
.globl vector181
vector181:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $181
801060f9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801060fe:	e9 4b f4 ff ff       	jmp    8010554e <alltraps>

80106103 <vector182>:
.globl vector182
vector182:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $182
80106105:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010610a:	e9 3f f4 ff ff       	jmp    8010554e <alltraps>

8010610f <vector183>:
.globl vector183
vector183:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $183
80106111:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106116:	e9 33 f4 ff ff       	jmp    8010554e <alltraps>

8010611b <vector184>:
.globl vector184
vector184:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $184
8010611d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106122:	e9 27 f4 ff ff       	jmp    8010554e <alltraps>

80106127 <vector185>:
.globl vector185
vector185:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $185
80106129:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010612e:	e9 1b f4 ff ff       	jmp    8010554e <alltraps>

80106133 <vector186>:
.globl vector186
vector186:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $186
80106135:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010613a:	e9 0f f4 ff ff       	jmp    8010554e <alltraps>

8010613f <vector187>:
.globl vector187
vector187:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $187
80106141:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106146:	e9 03 f4 ff ff       	jmp    8010554e <alltraps>

8010614b <vector188>:
.globl vector188
vector188:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $188
8010614d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106152:	e9 f7 f3 ff ff       	jmp    8010554e <alltraps>

80106157 <vector189>:
.globl vector189
vector189:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $189
80106159:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010615e:	e9 eb f3 ff ff       	jmp    8010554e <alltraps>

80106163 <vector190>:
.globl vector190
vector190:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $190
80106165:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010616a:	e9 df f3 ff ff       	jmp    8010554e <alltraps>

8010616f <vector191>:
.globl vector191
vector191:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $191
80106171:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106176:	e9 d3 f3 ff ff       	jmp    8010554e <alltraps>

8010617b <vector192>:
.globl vector192
vector192:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $192
8010617d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106182:	e9 c7 f3 ff ff       	jmp    8010554e <alltraps>

80106187 <vector193>:
.globl vector193
vector193:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $193
80106189:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010618e:	e9 bb f3 ff ff       	jmp    8010554e <alltraps>

80106193 <vector194>:
.globl vector194
vector194:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $194
80106195:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010619a:	e9 af f3 ff ff       	jmp    8010554e <alltraps>

8010619f <vector195>:
.globl vector195
vector195:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $195
801061a1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801061a6:	e9 a3 f3 ff ff       	jmp    8010554e <alltraps>

801061ab <vector196>:
.globl vector196
vector196:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $196
801061ad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801061b2:	e9 97 f3 ff ff       	jmp    8010554e <alltraps>

801061b7 <vector197>:
.globl vector197
vector197:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $197
801061b9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801061be:	e9 8b f3 ff ff       	jmp    8010554e <alltraps>

801061c3 <vector198>:
.globl vector198
vector198:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $198
801061c5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061ca:	e9 7f f3 ff ff       	jmp    8010554e <alltraps>

801061cf <vector199>:
.globl vector199
vector199:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $199
801061d1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801061d6:	e9 73 f3 ff ff       	jmp    8010554e <alltraps>

801061db <vector200>:
.globl vector200
vector200:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $200
801061dd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801061e2:	e9 67 f3 ff ff       	jmp    8010554e <alltraps>

801061e7 <vector201>:
.globl vector201
vector201:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $201
801061e9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801061ee:	e9 5b f3 ff ff       	jmp    8010554e <alltraps>

801061f3 <vector202>:
.globl vector202
vector202:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $202
801061f5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801061fa:	e9 4f f3 ff ff       	jmp    8010554e <alltraps>

801061ff <vector203>:
.globl vector203
vector203:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $203
80106201:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106206:	e9 43 f3 ff ff       	jmp    8010554e <alltraps>

8010620b <vector204>:
.globl vector204
vector204:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $204
8010620d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106212:	e9 37 f3 ff ff       	jmp    8010554e <alltraps>

80106217 <vector205>:
.globl vector205
vector205:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $205
80106219:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010621e:	e9 2b f3 ff ff       	jmp    8010554e <alltraps>

80106223 <vector206>:
.globl vector206
vector206:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $206
80106225:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010622a:	e9 1f f3 ff ff       	jmp    8010554e <alltraps>

8010622f <vector207>:
.globl vector207
vector207:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $207
80106231:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106236:	e9 13 f3 ff ff       	jmp    8010554e <alltraps>

8010623b <vector208>:
.globl vector208
vector208:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $208
8010623d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106242:	e9 07 f3 ff ff       	jmp    8010554e <alltraps>

80106247 <vector209>:
.globl vector209
vector209:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $209
80106249:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010624e:	e9 fb f2 ff ff       	jmp    8010554e <alltraps>

80106253 <vector210>:
.globl vector210
vector210:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $210
80106255:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010625a:	e9 ef f2 ff ff       	jmp    8010554e <alltraps>

8010625f <vector211>:
.globl vector211
vector211:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $211
80106261:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106266:	e9 e3 f2 ff ff       	jmp    8010554e <alltraps>

8010626b <vector212>:
.globl vector212
vector212:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $212
8010626d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106272:	e9 d7 f2 ff ff       	jmp    8010554e <alltraps>

80106277 <vector213>:
.globl vector213
vector213:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $213
80106279:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010627e:	e9 cb f2 ff ff       	jmp    8010554e <alltraps>

80106283 <vector214>:
.globl vector214
vector214:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $214
80106285:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010628a:	e9 bf f2 ff ff       	jmp    8010554e <alltraps>

8010628f <vector215>:
.globl vector215
vector215:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $215
80106291:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106296:	e9 b3 f2 ff ff       	jmp    8010554e <alltraps>

8010629b <vector216>:
.globl vector216
vector216:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $216
8010629d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801062a2:	e9 a7 f2 ff ff       	jmp    8010554e <alltraps>

801062a7 <vector217>:
.globl vector217
vector217:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $217
801062a9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801062ae:	e9 9b f2 ff ff       	jmp    8010554e <alltraps>

801062b3 <vector218>:
.globl vector218
vector218:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $218
801062b5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801062ba:	e9 8f f2 ff ff       	jmp    8010554e <alltraps>

801062bf <vector219>:
.globl vector219
vector219:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $219
801062c1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062c6:	e9 83 f2 ff ff       	jmp    8010554e <alltraps>

801062cb <vector220>:
.globl vector220
vector220:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $220
801062cd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062d2:	e9 77 f2 ff ff       	jmp    8010554e <alltraps>

801062d7 <vector221>:
.globl vector221
vector221:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $221
801062d9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801062de:	e9 6b f2 ff ff       	jmp    8010554e <alltraps>

801062e3 <vector222>:
.globl vector222
vector222:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $222
801062e5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801062ea:	e9 5f f2 ff ff       	jmp    8010554e <alltraps>

801062ef <vector223>:
.globl vector223
vector223:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $223
801062f1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801062f6:	e9 53 f2 ff ff       	jmp    8010554e <alltraps>

801062fb <vector224>:
.globl vector224
vector224:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $224
801062fd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106302:	e9 47 f2 ff ff       	jmp    8010554e <alltraps>

80106307 <vector225>:
.globl vector225
vector225:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $225
80106309:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010630e:	e9 3b f2 ff ff       	jmp    8010554e <alltraps>

80106313 <vector226>:
.globl vector226
vector226:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $226
80106315:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010631a:	e9 2f f2 ff ff       	jmp    8010554e <alltraps>

8010631f <vector227>:
.globl vector227
vector227:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $227
80106321:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106326:	e9 23 f2 ff ff       	jmp    8010554e <alltraps>

8010632b <vector228>:
.globl vector228
vector228:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $228
8010632d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106332:	e9 17 f2 ff ff       	jmp    8010554e <alltraps>

80106337 <vector229>:
.globl vector229
vector229:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $229
80106339:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010633e:	e9 0b f2 ff ff       	jmp    8010554e <alltraps>

80106343 <vector230>:
.globl vector230
vector230:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $230
80106345:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010634a:	e9 ff f1 ff ff       	jmp    8010554e <alltraps>

8010634f <vector231>:
.globl vector231
vector231:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $231
80106351:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106356:	e9 f3 f1 ff ff       	jmp    8010554e <alltraps>

8010635b <vector232>:
.globl vector232
vector232:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $232
8010635d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106362:	e9 e7 f1 ff ff       	jmp    8010554e <alltraps>

80106367 <vector233>:
.globl vector233
vector233:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $233
80106369:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010636e:	e9 db f1 ff ff       	jmp    8010554e <alltraps>

80106373 <vector234>:
.globl vector234
vector234:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $234
80106375:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010637a:	e9 cf f1 ff ff       	jmp    8010554e <alltraps>

8010637f <vector235>:
.globl vector235
vector235:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $235
80106381:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106386:	e9 c3 f1 ff ff       	jmp    8010554e <alltraps>

8010638b <vector236>:
.globl vector236
vector236:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $236
8010638d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106392:	e9 b7 f1 ff ff       	jmp    8010554e <alltraps>

80106397 <vector237>:
.globl vector237
vector237:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $237
80106399:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010639e:	e9 ab f1 ff ff       	jmp    8010554e <alltraps>

801063a3 <vector238>:
.globl vector238
vector238:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $238
801063a5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801063aa:	e9 9f f1 ff ff       	jmp    8010554e <alltraps>

801063af <vector239>:
.globl vector239
vector239:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $239
801063b1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801063b6:	e9 93 f1 ff ff       	jmp    8010554e <alltraps>

801063bb <vector240>:
.globl vector240
vector240:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $240
801063bd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801063c2:	e9 87 f1 ff ff       	jmp    8010554e <alltraps>

801063c7 <vector241>:
.globl vector241
vector241:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $241
801063c9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063ce:	e9 7b f1 ff ff       	jmp    8010554e <alltraps>

801063d3 <vector242>:
.globl vector242
vector242:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $242
801063d5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801063da:	e9 6f f1 ff ff       	jmp    8010554e <alltraps>

801063df <vector243>:
.globl vector243
vector243:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $243
801063e1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801063e6:	e9 63 f1 ff ff       	jmp    8010554e <alltraps>

801063eb <vector244>:
.globl vector244
vector244:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $244
801063ed:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801063f2:	e9 57 f1 ff ff       	jmp    8010554e <alltraps>

801063f7 <vector245>:
.globl vector245
vector245:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $245
801063f9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801063fe:	e9 4b f1 ff ff       	jmp    8010554e <alltraps>

80106403 <vector246>:
.globl vector246
vector246:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $246
80106405:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010640a:	e9 3f f1 ff ff       	jmp    8010554e <alltraps>

8010640f <vector247>:
.globl vector247
vector247:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $247
80106411:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106416:	e9 33 f1 ff ff       	jmp    8010554e <alltraps>

8010641b <vector248>:
.globl vector248
vector248:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $248
8010641d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106422:	e9 27 f1 ff ff       	jmp    8010554e <alltraps>

80106427 <vector249>:
.globl vector249
vector249:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $249
80106429:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010642e:	e9 1b f1 ff ff       	jmp    8010554e <alltraps>

80106433 <vector250>:
.globl vector250
vector250:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $250
80106435:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010643a:	e9 0f f1 ff ff       	jmp    8010554e <alltraps>

8010643f <vector251>:
.globl vector251
vector251:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $251
80106441:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106446:	e9 03 f1 ff ff       	jmp    8010554e <alltraps>

8010644b <vector252>:
.globl vector252
vector252:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $252
8010644d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106452:	e9 f7 f0 ff ff       	jmp    8010554e <alltraps>

80106457 <vector253>:
.globl vector253
vector253:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $253
80106459:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010645e:	e9 eb f0 ff ff       	jmp    8010554e <alltraps>

80106463 <vector254>:
.globl vector254
vector254:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $254
80106465:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010646a:	e9 df f0 ff ff       	jmp    8010554e <alltraps>

8010646f <vector255>:
.globl vector255
vector255:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $255
80106471:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106476:	e9 d3 f0 ff ff       	jmp    8010554e <alltraps>
8010647b:	66 90                	xchg   %ax,%ax
8010647d:	66 90                	xchg   %ax,%ax
8010647f:	90                   	nop

80106480 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	57                   	push   %edi
80106484:	56                   	push   %esi
80106485:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106487:	c1 ea 16             	shr    $0x16,%edx
{
8010648a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010648b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010648e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106491:	8b 1f                	mov    (%edi),%ebx
80106493:	f6 c3 01             	test   $0x1,%bl
80106496:	74 28                	je     801064c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106498:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010649e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801064a4:	89 f0                	mov    %esi,%eax
}
801064a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801064a9:	c1 e8 0a             	shr    $0xa,%eax
801064ac:	25 fc 0f 00 00       	and    $0xffc,%eax
801064b1:	01 d8                	add    %ebx,%eax
}
801064b3:	5b                   	pop    %ebx
801064b4:	5e                   	pop    %esi
801064b5:	5f                   	pop    %edi
801064b6:	5d                   	pop    %ebp
801064b7:	c3                   	ret    
801064b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064bf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801064c0:	85 c9                	test   %ecx,%ecx
801064c2:	74 2c                	je     801064f0 <walkpgdir+0x70>
801064c4:	e8 57 be ff ff       	call   80102320 <kalloc>
801064c9:	89 c3                	mov    %eax,%ebx
801064cb:	85 c0                	test   %eax,%eax
801064cd:	74 21                	je     801064f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801064cf:	83 ec 04             	sub    $0x4,%esp
801064d2:	68 00 10 00 00       	push   $0x1000
801064d7:	6a 00                	push   $0x0
801064d9:	50                   	push   %eax
801064da:	e8 31 de ff ff       	call   80104310 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801064df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064e5:	83 c4 10             	add    $0x10,%esp
801064e8:	83 c8 07             	or     $0x7,%eax
801064eb:	89 07                	mov    %eax,(%edi)
801064ed:	eb b5                	jmp    801064a4 <walkpgdir+0x24>
801064ef:	90                   	nop
}
801064f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801064f3:	31 c0                	xor    %eax,%eax
}
801064f5:	5b                   	pop    %ebx
801064f6:	5e                   	pop    %esi
801064f7:	5f                   	pop    %edi
801064f8:	5d                   	pop    %ebp
801064f9:	c3                   	ret    
801064fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106500 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	57                   	push   %edi
80106504:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106506:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010650a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010650b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106510:	89 d6                	mov    %edx,%esi
{
80106512:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106513:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106519:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010651c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010651f:	8b 45 08             	mov    0x8(%ebp),%eax
80106522:	29 f0                	sub    %esi,%eax
80106524:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106527:	eb 1f                	jmp    80106548 <mappages+0x48>
80106529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106530:	f6 00 01             	testb  $0x1,(%eax)
80106533:	75 45                	jne    8010657a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106535:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106538:	83 cb 01             	or     $0x1,%ebx
8010653b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010653d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106540:	74 2e                	je     80106570 <mappages+0x70>
      break;
    a += PGSIZE;
80106542:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010654b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106550:	89 f2                	mov    %esi,%edx
80106552:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106555:	89 f8                	mov    %edi,%eax
80106557:	e8 24 ff ff ff       	call   80106480 <walkpgdir>
8010655c:	85 c0                	test   %eax,%eax
8010655e:	75 d0                	jne    80106530 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106560:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106568:	5b                   	pop    %ebx
80106569:	5e                   	pop    %esi
8010656a:	5f                   	pop    %edi
8010656b:	5d                   	pop    %ebp
8010656c:	c3                   	ret    
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
80106570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106573:	31 c0                	xor    %eax,%eax
}
80106575:	5b                   	pop    %ebx
80106576:	5e                   	pop    %esi
80106577:	5f                   	pop    %edi
80106578:	5d                   	pop    %ebp
80106579:	c3                   	ret    
      panic("remap");
8010657a:	83 ec 0c             	sub    $0xc,%esp
8010657d:	68 0c 77 10 80       	push   $0x8010770c
80106582:	e8 09 9e ff ff       	call   80100390 <panic>
80106587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010658e:	66 90                	xchg   %ax,%ax

80106590 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	57                   	push   %edi
80106594:	56                   	push   %esi
80106595:	89 c6                	mov    %eax,%esi
80106597:	53                   	push   %ebx
80106598:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010659a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801065a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065a6:	83 ec 1c             	sub    $0x1c,%esp
801065a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801065ac:	39 da                	cmp    %ebx,%edx
801065ae:	73 5b                	jae    8010660b <deallocuvm.part.0+0x7b>
801065b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801065b3:	89 d7                	mov    %edx,%edi
801065b5:	eb 14                	jmp    801065cb <deallocuvm.part.0+0x3b>
801065b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065be:	66 90                	xchg   %ax,%ax
801065c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801065c6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801065c9:	76 40                	jbe    8010660b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801065cb:	31 c9                	xor    %ecx,%ecx
801065cd:	89 fa                	mov    %edi,%edx
801065cf:	89 f0                	mov    %esi,%eax
801065d1:	e8 aa fe ff ff       	call   80106480 <walkpgdir>
801065d6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801065d8:	85 c0                	test   %eax,%eax
801065da:	74 44                	je     80106620 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801065dc:	8b 00                	mov    (%eax),%eax
801065de:	a8 01                	test   $0x1,%al
801065e0:	74 de                	je     801065c0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801065e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801065e7:	74 47                	je     80106630 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801065e9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801065ec:	05 00 00 00 80       	add    $0x80000000,%eax
801065f1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801065f7:	50                   	push   %eax
801065f8:	e8 63 bb ff ff       	call   80102160 <kfree>
      *pte = 0;
801065fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106603:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106606:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106609:	77 c0                	ja     801065cb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010660b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010660e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106611:	5b                   	pop    %ebx
80106612:	5e                   	pop    %esi
80106613:	5f                   	pop    %edi
80106614:	5d                   	pop    %ebp
80106615:	c3                   	ret    
80106616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106620:	89 fa                	mov    %edi,%edx
80106622:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106628:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010662e:	eb 96                	jmp    801065c6 <deallocuvm.part.0+0x36>
        panic("kfree");
80106630:	83 ec 0c             	sub    $0xc,%esp
80106633:	68 be 70 10 80       	push   $0x801070be
80106638:	e8 53 9d ff ff       	call   80100390 <panic>
8010663d:	8d 76 00             	lea    0x0(%esi),%esi

80106640 <seginit>:
{
80106640:	f3 0f 1e fb          	endbr32 
80106644:	55                   	push   %ebp
80106645:	89 e5                	mov    %esp,%ebp
80106647:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010664a:	e8 e1 cf ff ff       	call   80103630 <cpuid>
  pd[0] = size-1;
8010664f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106654:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010665a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010665e:	c7 80 b8 f7 18 80 ff 	movl   $0xffff,-0x7fe70848(%eax)
80106665:	ff 00 00 
80106668:	c7 80 bc f7 18 80 00 	movl   $0xcf9a00,-0x7fe70844(%eax)
8010666f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106672:	c7 80 c0 f7 18 80 ff 	movl   $0xffff,-0x7fe70840(%eax)
80106679:	ff 00 00 
8010667c:	c7 80 c4 f7 18 80 00 	movl   $0xcf9200,-0x7fe7083c(%eax)
80106683:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106686:	c7 80 c8 f7 18 80 ff 	movl   $0xffff,-0x7fe70838(%eax)
8010668d:	ff 00 00 
80106690:	c7 80 cc f7 18 80 00 	movl   $0xcffa00,-0x7fe70834(%eax)
80106697:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010669a:	c7 80 d0 f7 18 80 ff 	movl   $0xffff,-0x7fe70830(%eax)
801066a1:	ff 00 00 
801066a4:	c7 80 d4 f7 18 80 00 	movl   $0xcff200,-0x7fe7082c(%eax)
801066ab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801066ae:	05 b0 f7 18 80       	add    $0x8018f7b0,%eax
  pd[1] = (uint)p;
801066b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801066b7:	c1 e8 10             	shr    $0x10,%eax
801066ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801066be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801066c1:	0f 01 10             	lgdtl  (%eax)
}
801066c4:	c9                   	leave  
801066c5:	c3                   	ret    
801066c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066cd:	8d 76 00             	lea    0x0(%esi),%esi

801066d0 <switchkvm>:
{
801066d0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801066d4:	a1 64 25 19 80       	mov    0x80192564,%eax
801066d9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066de:	0f 22 d8             	mov    %eax,%cr3
}
801066e1:	c3                   	ret    
801066e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066f0 <switchuvm>:
{
801066f0:	f3 0f 1e fb          	endbr32 
801066f4:	55                   	push   %ebp
801066f5:	89 e5                	mov    %esp,%ebp
801066f7:	57                   	push   %edi
801066f8:	56                   	push   %esi
801066f9:	53                   	push   %ebx
801066fa:	83 ec 1c             	sub    $0x1c,%esp
801066fd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106700:	85 f6                	test   %esi,%esi
80106702:	0f 84 cb 00 00 00    	je     801067d3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106708:	8b 46 0c             	mov    0xc(%esi),%eax
8010670b:	85 c0                	test   %eax,%eax
8010670d:	0f 84 da 00 00 00    	je     801067ed <switchuvm+0xfd>
  if(p->pgdir == 0)
80106713:	8b 46 08             	mov    0x8(%esi),%eax
80106716:	85 c0                	test   %eax,%eax
80106718:	0f 84 c2 00 00 00    	je     801067e0 <switchuvm+0xf0>
  pushcli();
8010671e:	e8 dd d9 ff ff       	call   80104100 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106723:	e8 98 ce ff ff       	call   801035c0 <mycpu>
80106728:	89 c3                	mov    %eax,%ebx
8010672a:	e8 91 ce ff ff       	call   801035c0 <mycpu>
8010672f:	89 c7                	mov    %eax,%edi
80106731:	e8 8a ce ff ff       	call   801035c0 <mycpu>
80106736:	83 c7 08             	add    $0x8,%edi
80106739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010673c:	e8 7f ce ff ff       	call   801035c0 <mycpu>
80106741:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106744:	ba 67 00 00 00       	mov    $0x67,%edx
80106749:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106750:	83 c0 08             	add    $0x8,%eax
80106753:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010675a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010675f:	83 c1 08             	add    $0x8,%ecx
80106762:	c1 e8 18             	shr    $0x18,%eax
80106765:	c1 e9 10             	shr    $0x10,%ecx
80106768:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010676e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106774:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106779:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106780:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106785:	e8 36 ce ff ff       	call   801035c0 <mycpu>
8010678a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106791:	e8 2a ce ff ff       	call   801035c0 <mycpu>
80106796:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010679a:	8b 5e 0c             	mov    0xc(%esi),%ebx
8010679d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067a3:	e8 18 ce ff ff       	call   801035c0 <mycpu>
801067a8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801067ab:	e8 10 ce ff ff       	call   801035c0 <mycpu>
801067b0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801067b4:	b8 28 00 00 00       	mov    $0x28,%eax
801067b9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801067bc:	8b 46 08             	mov    0x8(%esi),%eax
801067bf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801067c4:	0f 22 d8             	mov    %eax,%cr3
}
801067c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067ca:	5b                   	pop    %ebx
801067cb:	5e                   	pop    %esi
801067cc:	5f                   	pop    %edi
801067cd:	5d                   	pop    %ebp
  popcli();
801067ce:	e9 7d d9 ff ff       	jmp    80104150 <popcli>
    panic("switchuvm: no process");
801067d3:	83 ec 0c             	sub    $0xc,%esp
801067d6:	68 12 77 10 80       	push   $0x80107712
801067db:	e8 b0 9b ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801067e0:	83 ec 0c             	sub    $0xc,%esp
801067e3:	68 3d 77 10 80       	push   $0x8010773d
801067e8:	e8 a3 9b ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801067ed:	83 ec 0c             	sub    $0xc,%esp
801067f0:	68 28 77 10 80       	push   $0x80107728
801067f5:	e8 96 9b ff ff       	call   80100390 <panic>
801067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106800 <inituvm>:
{
80106800:	f3 0f 1e fb          	endbr32 
80106804:	55                   	push   %ebp
80106805:	89 e5                	mov    %esp,%ebp
80106807:	57                   	push   %edi
80106808:	56                   	push   %esi
80106809:	53                   	push   %ebx
8010680a:	83 ec 1c             	sub    $0x1c,%esp
8010680d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106810:	8b 75 10             	mov    0x10(%ebp),%esi
80106813:	8b 7d 08             	mov    0x8(%ebp),%edi
80106816:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106819:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010681f:	77 4b                	ja     8010686c <inituvm+0x6c>
  mem = kalloc();
80106821:	e8 fa ba ff ff       	call   80102320 <kalloc>
  memset(mem, 0, PGSIZE);
80106826:	83 ec 04             	sub    $0x4,%esp
80106829:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010682e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106830:	6a 00                	push   $0x0
80106832:	50                   	push   %eax
80106833:	e8 d8 da ff ff       	call   80104310 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106838:	58                   	pop    %eax
80106839:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010683f:	5a                   	pop    %edx
80106840:	6a 06                	push   $0x6
80106842:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106847:	31 d2                	xor    %edx,%edx
80106849:	50                   	push   %eax
8010684a:	89 f8                	mov    %edi,%eax
8010684c:	e8 af fc ff ff       	call   80106500 <mappages>
  memmove(mem, init, sz);
80106851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106854:	89 75 10             	mov    %esi,0x10(%ebp)
80106857:	83 c4 10             	add    $0x10,%esp
8010685a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010685d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106860:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106863:	5b                   	pop    %ebx
80106864:	5e                   	pop    %esi
80106865:	5f                   	pop    %edi
80106866:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106867:	e9 44 db ff ff       	jmp    801043b0 <memmove>
    panic("inituvm: more than a page");
8010686c:	83 ec 0c             	sub    $0xc,%esp
8010686f:	68 51 77 10 80       	push   $0x80107751
80106874:	e8 17 9b ff ff       	call   80100390 <panic>
80106879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106880 <loaduvm>:
{
80106880:	f3 0f 1e fb          	endbr32 
80106884:	55                   	push   %ebp
80106885:	89 e5                	mov    %esp,%ebp
80106887:	57                   	push   %edi
80106888:	56                   	push   %esi
80106889:	53                   	push   %ebx
8010688a:	83 ec 1c             	sub    $0x1c,%esp
8010688d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106890:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106893:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106898:	0f 85 99 00 00 00    	jne    80106937 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010689e:	01 f0                	add    %esi,%eax
801068a0:	89 f3                	mov    %esi,%ebx
801068a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801068a5:	8b 45 14             	mov    0x14(%ebp),%eax
801068a8:	01 f0                	add    %esi,%eax
801068aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801068ad:	85 f6                	test   %esi,%esi
801068af:	75 15                	jne    801068c6 <loaduvm+0x46>
801068b1:	eb 6d                	jmp    80106920 <loaduvm+0xa0>
801068b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068b7:	90                   	nop
801068b8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801068be:	89 f0                	mov    %esi,%eax
801068c0:	29 d8                	sub    %ebx,%eax
801068c2:	39 c6                	cmp    %eax,%esi
801068c4:	76 5a                	jbe    80106920 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801068c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801068c9:	8b 45 08             	mov    0x8(%ebp),%eax
801068cc:	31 c9                	xor    %ecx,%ecx
801068ce:	29 da                	sub    %ebx,%edx
801068d0:	e8 ab fb ff ff       	call   80106480 <walkpgdir>
801068d5:	85 c0                	test   %eax,%eax
801068d7:	74 51                	je     8010692a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801068d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801068db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801068de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801068e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801068e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801068ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801068f1:	29 d9                	sub    %ebx,%ecx
801068f3:	05 00 00 00 80       	add    $0x80000000,%eax
801068f8:	57                   	push   %edi
801068f9:	51                   	push   %ecx
801068fa:	50                   	push   %eax
801068fb:	ff 75 10             	pushl  0x10(%ebp)
801068fe:	e8 5d b1 ff ff       	call   80101a60 <readi>
80106903:	83 c4 10             	add    $0x10,%esp
80106906:	39 f8                	cmp    %edi,%eax
80106908:	74 ae                	je     801068b8 <loaduvm+0x38>
}
8010690a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010690d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106912:	5b                   	pop    %ebx
80106913:	5e                   	pop    %esi
80106914:	5f                   	pop    %edi
80106915:	5d                   	pop    %ebp
80106916:	c3                   	ret    
80106917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010691e:	66 90                	xchg   %ax,%ax
80106920:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106923:	31 c0                	xor    %eax,%eax
}
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
      panic("loaduvm: address should exist");
8010692a:	83 ec 0c             	sub    $0xc,%esp
8010692d:	68 6b 77 10 80       	push   $0x8010776b
80106932:	e8 59 9a ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106937:	83 ec 0c             	sub    $0xc,%esp
8010693a:	68 0c 78 10 80       	push   $0x8010780c
8010693f:	e8 4c 9a ff ff       	call   80100390 <panic>
80106944:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010694b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010694f:	90                   	nop

80106950 <allocuvm>:
{
80106950:	f3 0f 1e fb          	endbr32 
80106954:	55                   	push   %ebp
80106955:	89 e5                	mov    %esp,%ebp
80106957:	57                   	push   %edi
80106958:	56                   	push   %esi
80106959:	53                   	push   %ebx
8010695a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010695d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106960:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106966:	85 c0                	test   %eax,%eax
80106968:	0f 88 b2 00 00 00    	js     80106a20 <allocuvm+0xd0>
  if(newsz < oldsz)
8010696e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106971:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106974:	0f 82 96 00 00 00    	jb     80106a10 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010697a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106980:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106986:	39 75 10             	cmp    %esi,0x10(%ebp)
80106989:	77 40                	ja     801069cb <allocuvm+0x7b>
8010698b:	e9 83 00 00 00       	jmp    80106a13 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106990:	83 ec 04             	sub    $0x4,%esp
80106993:	68 00 10 00 00       	push   $0x1000
80106998:	6a 00                	push   $0x0
8010699a:	50                   	push   %eax
8010699b:	e8 70 d9 ff ff       	call   80104310 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801069a0:	58                   	pop    %eax
801069a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069a7:	5a                   	pop    %edx
801069a8:	6a 06                	push   $0x6
801069aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801069af:	89 f2                	mov    %esi,%edx
801069b1:	50                   	push   %eax
801069b2:	89 f8                	mov    %edi,%eax
801069b4:	e8 47 fb ff ff       	call   80106500 <mappages>
801069b9:	83 c4 10             	add    $0x10,%esp
801069bc:	85 c0                	test   %eax,%eax
801069be:	78 78                	js     80106a38 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801069c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801069c9:	76 48                	jbe    80106a13 <allocuvm+0xc3>
    mem = kalloc();
801069cb:	e8 50 b9 ff ff       	call   80102320 <kalloc>
801069d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801069d2:	85 c0                	test   %eax,%eax
801069d4:	75 ba                	jne    80106990 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801069d6:	83 ec 0c             	sub    $0xc,%esp
801069d9:	68 89 77 10 80       	push   $0x80107789
801069de:	e8 cd 9c ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801069e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801069e6:	83 c4 10             	add    $0x10,%esp
801069e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801069ec:	74 32                	je     80106a20 <allocuvm+0xd0>
801069ee:	8b 55 10             	mov    0x10(%ebp),%edx
801069f1:	89 c1                	mov    %eax,%ecx
801069f3:	89 f8                	mov    %edi,%eax
801069f5:	e8 96 fb ff ff       	call   80106590 <deallocuvm.part.0>
      return 0;
801069fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a07:	5b                   	pop    %ebx
80106a08:	5e                   	pop    %esi
80106a09:	5f                   	pop    %edi
80106a0a:	5d                   	pop    %ebp
80106a0b:	c3                   	ret    
80106a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a19:	5b                   	pop    %ebx
80106a1a:	5e                   	pop    %esi
80106a1b:	5f                   	pop    %edi
80106a1c:	5d                   	pop    %ebp
80106a1d:	c3                   	ret    
80106a1e:	66 90                	xchg   %ax,%ax
    return 0;
80106a20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a2d:	5b                   	pop    %ebx
80106a2e:	5e                   	pop    %esi
80106a2f:	5f                   	pop    %edi
80106a30:	5d                   	pop    %ebp
80106a31:	c3                   	ret    
80106a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106a38:	83 ec 0c             	sub    $0xc,%esp
80106a3b:	68 a1 77 10 80       	push   $0x801077a1
80106a40:	e8 6b 9c ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106a45:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a48:	83 c4 10             	add    $0x10,%esp
80106a4b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106a4e:	74 0c                	je     80106a5c <allocuvm+0x10c>
80106a50:	8b 55 10             	mov    0x10(%ebp),%edx
80106a53:	89 c1                	mov    %eax,%ecx
80106a55:	89 f8                	mov    %edi,%eax
80106a57:	e8 34 fb ff ff       	call   80106590 <deallocuvm.part.0>
      kfree(mem);
80106a5c:	83 ec 0c             	sub    $0xc,%esp
80106a5f:	53                   	push   %ebx
80106a60:	e8 fb b6 ff ff       	call   80102160 <kfree>
      return 0;
80106a65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106a6c:	83 c4 10             	add    $0x10,%esp
}
80106a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5f                   	pop    %edi
80106a78:	5d                   	pop    %ebp
80106a79:	c3                   	ret    
80106a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a80 <deallocuvm>:
{
80106a80:	f3 0f 1e fb          	endbr32 
80106a84:	55                   	push   %ebp
80106a85:	89 e5                	mov    %esp,%ebp
80106a87:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106a90:	39 d1                	cmp    %edx,%ecx
80106a92:	73 0c                	jae    80106aa0 <deallocuvm+0x20>
}
80106a94:	5d                   	pop    %ebp
80106a95:	e9 f6 fa ff ff       	jmp    80106590 <deallocuvm.part.0>
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106aa0:	89 d0                	mov    %edx,%eax
80106aa2:	5d                   	pop    %ebp
80106aa3:	c3                   	ret    
80106aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106aaf:	90                   	nop

80106ab0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ab0:	f3 0f 1e fb          	endbr32 
80106ab4:	55                   	push   %ebp
80106ab5:	89 e5                	mov    %esp,%ebp
80106ab7:	57                   	push   %edi
80106ab8:	56                   	push   %esi
80106ab9:	53                   	push   %ebx
80106aba:	83 ec 0c             	sub    $0xc,%esp
80106abd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ac0:	85 f6                	test   %esi,%esi
80106ac2:	74 55                	je     80106b19 <freevm+0x69>
  if(newsz >= oldsz)
80106ac4:	31 c9                	xor    %ecx,%ecx
80106ac6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106acb:	89 f0                	mov    %esi,%eax
80106acd:	89 f3                	mov    %esi,%ebx
80106acf:	e8 bc fa ff ff       	call   80106590 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ad4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ada:	eb 0b                	jmp    80106ae7 <freevm+0x37>
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ae0:	83 c3 04             	add    $0x4,%ebx
80106ae3:	39 df                	cmp    %ebx,%edi
80106ae5:	74 23                	je     80106b0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ae7:	8b 03                	mov    (%ebx),%eax
80106ae9:	a8 01                	test   $0x1,%al
80106aeb:	74 f3                	je     80106ae0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106af2:	83 ec 0c             	sub    $0xc,%esp
80106af5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106af8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106afd:	50                   	push   %eax
80106afe:	e8 5d b6 ff ff       	call   80102160 <kfree>
80106b03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106b06:	39 df                	cmp    %ebx,%edi
80106b08:	75 dd                	jne    80106ae7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106b0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b10:	5b                   	pop    %ebx
80106b11:	5e                   	pop    %esi
80106b12:	5f                   	pop    %edi
80106b13:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106b14:	e9 47 b6 ff ff       	jmp    80102160 <kfree>
    panic("freevm: no pgdir");
80106b19:	83 ec 0c             	sub    $0xc,%esp
80106b1c:	68 bd 77 10 80       	push   $0x801077bd
80106b21:	e8 6a 98 ff ff       	call   80100390 <panic>
80106b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi

80106b30 <setupkvm>:
{
80106b30:	f3 0f 1e fb          	endbr32 
80106b34:	55                   	push   %ebp
80106b35:	89 e5                	mov    %esp,%ebp
80106b37:	56                   	push   %esi
80106b38:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106b39:	e8 e2 b7 ff ff       	call   80102320 <kalloc>
80106b3e:	89 c6                	mov    %eax,%esi
80106b40:	85 c0                	test   %eax,%eax
80106b42:	74 42                	je     80106b86 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106b44:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b47:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106b4c:	68 00 10 00 00       	push   $0x1000
80106b51:	6a 00                	push   $0x0
80106b53:	50                   	push   %eax
80106b54:	e8 b7 d7 ff ff       	call   80104310 <memset>
80106b59:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106b5c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b5f:	83 ec 08             	sub    $0x8,%esp
80106b62:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106b65:	ff 73 0c             	pushl  0xc(%ebx)
80106b68:	8b 13                	mov    (%ebx),%edx
80106b6a:	50                   	push   %eax
80106b6b:	29 c1                	sub    %eax,%ecx
80106b6d:	89 f0                	mov    %esi,%eax
80106b6f:	e8 8c f9 ff ff       	call   80106500 <mappages>
80106b74:	83 c4 10             	add    $0x10,%esp
80106b77:	85 c0                	test   %eax,%eax
80106b79:	78 15                	js     80106b90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b7b:	83 c3 10             	add    $0x10,%ebx
80106b7e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b84:	75 d6                	jne    80106b5c <setupkvm+0x2c>
}
80106b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b89:	89 f0                	mov    %esi,%eax
80106b8b:	5b                   	pop    %ebx
80106b8c:	5e                   	pop    %esi
80106b8d:	5d                   	pop    %ebp
80106b8e:	c3                   	ret    
80106b8f:	90                   	nop
      freevm(pgdir);
80106b90:	83 ec 0c             	sub    $0xc,%esp
80106b93:	56                   	push   %esi
      return 0;
80106b94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106b96:	e8 15 ff ff ff       	call   80106ab0 <freevm>
      return 0;
80106b9b:	83 c4 10             	add    $0x10,%esp
}
80106b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ba1:	89 f0                	mov    %esi,%eax
80106ba3:	5b                   	pop    %ebx
80106ba4:	5e                   	pop    %esi
80106ba5:	5d                   	pop    %ebp
80106ba6:	c3                   	ret    
80106ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bae:	66 90                	xchg   %ax,%ax

80106bb0 <kvmalloc>:
{
80106bb0:	f3 0f 1e fb          	endbr32 
80106bb4:	55                   	push   %ebp
80106bb5:	89 e5                	mov    %esp,%ebp
80106bb7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106bba:	e8 71 ff ff ff       	call   80106b30 <setupkvm>
80106bbf:	a3 64 25 19 80       	mov    %eax,0x80192564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bc4:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc9:	0f 22 d8             	mov    %eax,%cr3
}
80106bcc:	c9                   	leave  
80106bcd:	c3                   	ret    
80106bce:	66 90                	xchg   %ax,%ax

80106bd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106bd0:	f3 0f 1e fb          	endbr32 
80106bd4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106bd5:	31 c9                	xor    %ecx,%ecx
{
80106bd7:	89 e5                	mov    %esp,%ebp
80106bd9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80106be2:	e8 99 f8 ff ff       	call   80106480 <walkpgdir>
  if(pte == 0)
80106be7:	85 c0                	test   %eax,%eax
80106be9:	74 05                	je     80106bf0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106beb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106bee:	c9                   	leave  
80106bef:	c3                   	ret    
    panic("clearpteu");
80106bf0:	83 ec 0c             	sub    $0xc,%esp
80106bf3:	68 ce 77 10 80       	push   $0x801077ce
80106bf8:	e8 93 97 ff ff       	call   80100390 <panic>
80106bfd:	8d 76 00             	lea    0x0(%esi),%esi

80106c00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106c00:	f3 0f 1e fb          	endbr32 
80106c04:	55                   	push   %ebp
80106c05:	89 e5                	mov    %esp,%ebp
80106c07:	57                   	push   %edi
80106c08:	56                   	push   %esi
80106c09:	53                   	push   %ebx
80106c0a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106c0d:	e8 1e ff ff ff       	call   80106b30 <setupkvm>
80106c12:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c15:	85 c0                	test   %eax,%eax
80106c17:	0f 84 9b 00 00 00    	je     80106cb8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c20:	85 c9                	test   %ecx,%ecx
80106c22:	0f 84 90 00 00 00    	je     80106cb8 <copyuvm+0xb8>
80106c28:	31 f6                	xor    %esi,%esi
80106c2a:	eb 46                	jmp    80106c72 <copyuvm+0x72>
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c30:	83 ec 04             	sub    $0x4,%esp
80106c33:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c39:	68 00 10 00 00       	push   $0x1000
80106c3e:	57                   	push   %edi
80106c3f:	50                   	push   %eax
80106c40:	e8 6b d7 ff ff       	call   801043b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106c45:	58                   	pop    %eax
80106c46:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c4c:	5a                   	pop    %edx
80106c4d:	ff 75 e4             	pushl  -0x1c(%ebp)
80106c50:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c55:	89 f2                	mov    %esi,%edx
80106c57:	50                   	push   %eax
80106c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c5b:	e8 a0 f8 ff ff       	call   80106500 <mappages>
80106c60:	83 c4 10             	add    $0x10,%esp
80106c63:	85 c0                	test   %eax,%eax
80106c65:	78 61                	js     80106cc8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106c67:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c6d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106c70:	76 46                	jbe    80106cb8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106c72:	8b 45 08             	mov    0x8(%ebp),%eax
80106c75:	31 c9                	xor    %ecx,%ecx
80106c77:	89 f2                	mov    %esi,%edx
80106c79:	e8 02 f8 ff ff       	call   80106480 <walkpgdir>
80106c7e:	85 c0                	test   %eax,%eax
80106c80:	74 61                	je     80106ce3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106c82:	8b 00                	mov    (%eax),%eax
80106c84:	a8 01                	test   $0x1,%al
80106c86:	74 4e                	je     80106cd6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106c88:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80106c8a:	25 ff 0f 00 00       	and    $0xfff,%eax
80106c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106c92:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106c98:	e8 83 b6 ff ff       	call   80102320 <kalloc>
80106c9d:	89 c3                	mov    %eax,%ebx
80106c9f:	85 c0                	test   %eax,%eax
80106ca1:	75 8d                	jne    80106c30 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106ca3:	83 ec 0c             	sub    $0xc,%esp
80106ca6:	ff 75 e0             	pushl  -0x20(%ebp)
80106ca9:	e8 02 fe ff ff       	call   80106ab0 <freevm>
  return 0;
80106cae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106cb5:	83 c4 10             	add    $0x10,%esp
}
80106cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cbe:	5b                   	pop    %ebx
80106cbf:	5e                   	pop    %esi
80106cc0:	5f                   	pop    %edi
80106cc1:	5d                   	pop    %ebp
80106cc2:	c3                   	ret    
80106cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cc7:	90                   	nop
      kfree(mem);
80106cc8:	83 ec 0c             	sub    $0xc,%esp
80106ccb:	53                   	push   %ebx
80106ccc:	e8 8f b4 ff ff       	call   80102160 <kfree>
      goto bad;
80106cd1:	83 c4 10             	add    $0x10,%esp
80106cd4:	eb cd                	jmp    80106ca3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106cd6:	83 ec 0c             	sub    $0xc,%esp
80106cd9:	68 f2 77 10 80       	push   $0x801077f2
80106cde:	e8 ad 96 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106ce3:	83 ec 0c             	sub    $0xc,%esp
80106ce6:	68 d8 77 10 80       	push   $0x801077d8
80106ceb:	e8 a0 96 ff ff       	call   80100390 <panic>

80106cf0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106cf0:	f3 0f 1e fb          	endbr32 
80106cf4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cf5:	31 c9                	xor    %ecx,%ecx
{
80106cf7:	89 e5                	mov    %esp,%ebp
80106cf9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cff:	8b 45 08             	mov    0x8(%ebp),%eax
80106d02:	e8 79 f7 ff ff       	call   80106480 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106d07:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106d09:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106d0a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106d0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106d11:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106d14:	05 00 00 00 80       	add    $0x80000000,%eax
80106d19:	83 fa 05             	cmp    $0x5,%edx
80106d1c:	ba 00 00 00 00       	mov    $0x0,%edx
80106d21:	0f 45 c2             	cmovne %edx,%eax
}
80106d24:	c3                   	ret    
80106d25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d30:	f3 0f 1e fb          	endbr32 
80106d34:	55                   	push   %ebp
80106d35:	89 e5                	mov    %esp,%ebp
80106d37:	57                   	push   %edi
80106d38:	56                   	push   %esi
80106d39:	53                   	push   %ebx
80106d3a:	83 ec 0c             	sub    $0xc,%esp
80106d3d:	8b 75 14             	mov    0x14(%ebp),%esi
80106d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d43:	85 f6                	test   %esi,%esi
80106d45:	75 3c                	jne    80106d83 <copyout+0x53>
80106d47:	eb 67                	jmp    80106db0 <copyout+0x80>
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d50:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d53:	89 fb                	mov    %edi,%ebx
80106d55:	29 d3                	sub    %edx,%ebx
80106d57:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106d5d:	39 f3                	cmp    %esi,%ebx
80106d5f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d62:	29 fa                	sub    %edi,%edx
80106d64:	83 ec 04             	sub    $0x4,%esp
80106d67:	01 c2                	add    %eax,%edx
80106d69:	53                   	push   %ebx
80106d6a:	ff 75 10             	pushl  0x10(%ebp)
80106d6d:	52                   	push   %edx
80106d6e:	e8 3d d6 ff ff       	call   801043b0 <memmove>
    len -= n;
    buf += n;
80106d73:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106d76:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106d7c:	83 c4 10             	add    $0x10,%esp
80106d7f:	29 de                	sub    %ebx,%esi
80106d81:	74 2d                	je     80106db0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106d83:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d85:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106d88:	89 55 0c             	mov    %edx,0xc(%ebp)
80106d8b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d91:	57                   	push   %edi
80106d92:	ff 75 08             	pushl  0x8(%ebp)
80106d95:	e8 56 ff ff ff       	call   80106cf0 <uva2ka>
    if(pa0 == 0)
80106d9a:	83 c4 10             	add    $0x10,%esp
80106d9d:	85 c0                	test   %eax,%eax
80106d9f:	75 af                	jne    80106d50 <copyout+0x20>
  }
  return 0;
}
80106da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106da4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106da9:	5b                   	pop    %ebx
80106daa:	5e                   	pop    %esi
80106dab:	5f                   	pop    %edi
80106dac:	5d                   	pop    %ebp
80106dad:	c3                   	ret    
80106dae:	66 90                	xchg   %ax,%ax
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106db3:	31 c0                	xor    %eax,%eax
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5f                   	pop    %edi
80106db8:	5d                   	pop    %ebp
80106db9:	c3                   	ret    
80106dba:	66 90                	xchg   %ax,%ax
80106dbc:	66 90                	xchg   %ax,%ax
80106dbe:	66 90                	xchg   %ax,%ax

80106dc0 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
80106dc0:	f3 0f 1e fb          	endbr32 
  memdisk = _binary_fs_img_start;
80106dc4:	c7 05 68 75 18 80 16 	movl   $0x8010a516,0x80187568
80106dcb:	a5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
80106dce:	b8 00 d0 07 00       	mov    $0x7d000,%eax
80106dd3:	c1 e8 09             	shr    $0x9,%eax
80106dd6:	a3 6c 75 18 80       	mov    %eax,0x8018756c
}
80106ddb:	c3                   	ret    
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106de0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80106de0:	f3 0f 1e fb          	endbr32 
  // no-op
}
80106de4:	c3                   	ret    
80106de5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106df0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80106df0:	f3 0f 1e fb          	endbr32 
80106df4:	55                   	push   %ebp
80106df5:	89 e5                	mov    %esp,%ebp
80106df7:	53                   	push   %ebx
80106df8:	83 ec 10             	sub    $0x10,%esp
80106dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uchar *p;

  if(!holdingsleep(&b->lock))
80106dfe:	8d 43 0c             	lea    0xc(%ebx),%eax
80106e01:	50                   	push   %eax
80106e02:	e8 19 d2 ff ff       	call   80104020 <holdingsleep>
80106e07:	83 c4 10             	add    $0x10,%esp
80106e0a:	85 c0                	test   %eax,%eax
80106e0c:	0f 84 94 00 00 00    	je     80106ea6 <iderw+0xb6>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80106e12:	8b 13                	mov    (%ebx),%edx
80106e14:	89 d0                	mov    %edx,%eax
80106e16:	83 e0 06             	and    $0x6,%eax
80106e19:	83 f8 02             	cmp    $0x2,%eax
80106e1c:	74 7b                	je     80106e99 <iderw+0xa9>
    panic("iderw: nothing to do");
  if(b->dev != 1)
80106e1e:	83 7b 04 01          	cmpl   $0x1,0x4(%ebx)
80106e22:	75 68                	jne    80106e8c <iderw+0x9c>
    panic("iderw: request not for disk 1");
  if(b->blockno >= disksize)
80106e24:	8b 43 08             	mov    0x8(%ebx),%eax
80106e27:	3b 05 6c 75 18 80    	cmp    0x8018756c,%eax
80106e2d:	73 50                	jae    80106e7f <iderw+0x8f>
    panic("iderw: block out of range");

  p = memdisk + b->blockno*BSIZE;
80106e2f:	c1 e0 09             	shl    $0x9,%eax
80106e32:	8d 4b 5c             	lea    0x5c(%ebx),%ecx
80106e35:	03 05 68 75 18 80    	add    0x80187568,%eax

  if(b->flags & B_DIRTY){
80106e3b:	f6 c2 04             	test   $0x4,%dl
80106e3e:	75 20                	jne    80106e60 <iderw+0x70>
    b->flags &= ~B_DIRTY;
    memmove(p, b->data, BSIZE);
  } else
    memmove(b->data, p, BSIZE);
80106e40:	83 ec 04             	sub    $0x4,%esp
80106e43:	68 00 02 00 00       	push   $0x200
80106e48:	50                   	push   %eax
80106e49:	51                   	push   %ecx
80106e4a:	e8 61 d5 ff ff       	call   801043b0 <memmove>
  b->flags |= B_VALID;
80106e4f:	83 0b 02             	orl    $0x2,(%ebx)
    memmove(b->data, p, BSIZE);
80106e52:	83 c4 10             	add    $0x10,%esp
}
80106e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106e58:	c9                   	leave  
80106e59:	c3                   	ret    
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(p, b->data, BSIZE);
80106e60:	83 ec 04             	sub    $0x4,%esp
    b->flags &= ~B_DIRTY;
80106e63:	83 e2 fb             	and    $0xfffffffb,%edx
80106e66:	89 13                	mov    %edx,(%ebx)
    memmove(p, b->data, BSIZE);
80106e68:	68 00 02 00 00       	push   $0x200
80106e6d:	51                   	push   %ecx
80106e6e:	50                   	push   %eax
80106e6f:	e8 3c d5 ff ff       	call   801043b0 <memmove>
  b->flags |= B_VALID;
80106e74:	83 0b 02             	orl    $0x2,(%ebx)
80106e77:	83 c4 10             	add    $0x10,%esp
}
80106e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106e7d:	c9                   	leave  
80106e7e:	c3                   	ret    
    panic("iderw: block out of range");
80106e7f:	83 ec 0c             	sub    $0xc,%esp
80106e82:	68 78 78 10 80       	push   $0x80107878
80106e87:	e8 04 95 ff ff       	call   80100390 <panic>
    panic("iderw: request not for disk 1");
80106e8c:	83 ec 0c             	sub    $0xc,%esp
80106e8f:	68 5a 78 10 80       	push   $0x8010785a
80106e94:	e8 f7 94 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80106e99:	83 ec 0c             	sub    $0xc,%esp
80106e9c:	68 45 78 10 80       	push   $0x80107845
80106ea1:	e8 ea 94 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	68 2f 78 10 80       	push   $0x8010782f
80106eae:	e8 dd 94 ff ff       	call   80100390 <panic>
